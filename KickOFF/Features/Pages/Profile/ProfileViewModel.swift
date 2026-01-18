import Foundation
import UIKit

class ProfileViewModel {
    private let authService: FirebaseAuthService
    private let interestService: InterestService
    private let storageService: StorageService
    var currentUser: User?
    private var pendiongOperations: Int = 0
    
    var onError: ((String) -> Void)?
    var onUserLoaded: ((User) -> Void)?
    
    var onLogoutSuccess: (() -> Void)?
    var onLogoutError: ((String) -> Void)?
    var onInterestsLoaded: (() -> Void)?
    var onUserInterestsUpdated: (() -> Void)?
    var onSaveComplete: (() -> Void)?
    var onImageUploadSuccess: ((String) -> Void)?
    var onProfileUpdateSuccess: (() -> Void)?
    var onImagePreloaded: ((UIImage) -> Void)?
    var isLoading: Bool = false
    
    private(set) var interests: [Interest] = []
    private(set) var userInterests: [Interest] = []
    
    init(authService: FirebaseAuthService = .shared, interestService: InterestService = InterestService(), storageService: StorageService = .shared) {
        self.authService = authService
        self.interestService = interestService
        self.storageService = storageService
    }
    
    func logout() {
        do {
            try authService.logOut()
            onLogoutSuccess?()
        } catch {
            let errorMessage = error.localizedDescription
            onLogoutError?(errorMessage)
        }
    }
    
    func loadCurrentUser() {
        Task {
            do {
                guard let user = try await authService.getCurrentUser() else {
                    await MainActor.run {
                        onError?("მომხმარებელი ვერ მოიძებნა")
                    }
                    return
                }
                
                await MainActor.run {
                    currentUser = user
                    onUserLoaded?(user)
                }
            } catch {
                await MainActor.run {
                    onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func hasChanges(name: String, email: String, hasNewImage: Bool) -> Bool {
        guard let user = currentUser else { return false }
        
        let textChanged = name != user.name || email != user.email
        return textChanged || hasNewImage
    }
    
    func saveChanges(name: String, email: String, image: UIImage?) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty else {
            onError?("შეავსეთ ყველა ველი")
            return
        }
        
        let needsImageUpload = image != nil
        let needsProfileUpdate = trimmedName != currentUser?.name || trimmedEmail != currentUser?.email
        
        guard needsImageUpload || needsProfileUpdate else {
            onError?("ცვლილებები არ არის")
            return
        }
        
        pendiongOperations = 0
        if needsImageUpload { pendiongOperations += 1 }
        if needsProfileUpdate { pendiongOperations += 1 }
        
        if needsImageUpload, let image = image {
            uploadProfileImage(image, name: trimmedName, email: trimmedEmail)
        } else if needsProfileUpdate {
            updateProfile(name: trimmedName, email: trimmedEmail)
        }
    }
    
    
    private func uploadProfileImage(_ image: UIImage, name: String? = nil, email: String? = nil) {
        Task {
            do {
                guard let user = try await authService.getCurrentUser() else {
                    await MainActor.run {
                        onError?("მომხმარებელი ვერ მოიძებნა")
                        decrementOperations()
                    }
                    return
                }
                
                guard let uid = user.id else {
                    await MainActor.run {
                        onError?("User ID ვერ მოიძებნა")
                        decrementOperations()
                    }
                    return
                }
                
                let imageUrl = try await storageService.uploadProfileImage(image, uid: uid)
                try await authService.updateProfileImage(imageUrl: imageUrl)
                
                let needsProfileUpdate = (name != nil && name != currentUser?.name) || (email != nil && email != currentUser?.email)
                if needsProfileUpdate, let name = name, let email = email {
                    try await authService.updateProfile(name: name, email: email)
                }
                
                if let user = currentUser {
                    currentUser = User(
                        id: user.id,
                        name: name ?? user.name,
                        email: email ?? user.email,
                        createdAt: user.createdAt,
                        profileImageUrl: imageUrl,
                        interestIds: user.interestIds
                    )
                }
                
                await MainActor.run {
                    onImageUploadSuccess?(imageUrl)
                    decrementOperations()
                }
            } catch {
                await MainActor.run {
                    onError?(error.localizedDescription)
                    decrementOperations()
                }
            }
        }
    }
    
    private func updateProfile(name: String, email: String) {
        Task {
            do {
                try await authService.updateProfile(name: name, email: email)
                
                if let user = currentUser {
                    currentUser = User(
                        id: user.id,
                        name: name,
                        email: email,
                        createdAt: user.createdAt,
                        profileImageUrl: user.profileImageUrl,
                        interestIds: user.interestIds
                    )
                }
                
                await MainActor.run {
                    onProfileUpdateSuccess?()
                    decrementOperations()
                }
            } catch {
                await MainActor.run {
                    onError?(error.localizedDescription)
                    decrementOperations()
                }
            }
        }
    }
    
    func fetchInterests() {
        isLoading = true
        
        Task { [weak self] in
            let interests = await self?.interestService.fetchInterests() ?? []
            
            await MainActor.run {
                self?.interests = interests
                self?.isLoading = false
                if self?.currentUser != nil {
                    self?.updateUserInterests()
                }
                self?.onInterestsLoaded?()
            }
        }
    }
    
    func updateUserInterests() {
        let ids = currentUser?.interestIds ?? []
        userInterests = ids.compactMap { id in interests.first(where: { $0.id == id}) }
        onUserInterestsUpdated?()
    }
    
    func addUserInterest(_ interest: Interest, onComplete: (() -> Void)? = nil) {
        guard let uid = currentUser?.id else {
            onError?("მომხმარებელი ვერ მოიძებნა")
            return
        }
        Task {
            do {
                try await interestService.addUserInterest(uid: uid, interestId: interest.id)
                await MainActor.run {
                    var ids = currentUser?.interestIds ?? []
                    if !ids.contains(interest.id) { ids.append(interest.id)
                    }
                    currentUser = currentUser.flatMap { User(id: $0.id, name: $0.name, email: $0.email, createdAt: $0.createdAt, profileImageUrl: $0.profileImageUrl, interestIds: ids)}
                    updateUserInterests()
                    onComplete?()
                }
            } catch {
                await MainActor.run {
                    onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func removeUserInterest(_ interest: Interest, onComplete: (() -> Void)? = nil) {
        guard let uid = currentUser?.id else {
            onError?("მომხმარებელი ვერ მოიძებნა")
            return
        }
        Task {
            do {
                try await interestService.removeUserInterest(uid: uid, interestId: interest.id)
                await MainActor.run {
                    let ids = (currentUser?.interestIds ?? []).filter { $0 != interest.id }
                    currentUser = currentUser.flatMap { User(id: $0.id, name: $0.name, email: $0.email, createdAt: $0.createdAt, profileImageUrl: $0.profileImageUrl, interestIds: ids) }
                    updateUserInterests()
                    onComplete?()
                }
            } catch {
                await MainActor.run { onError?(error.localizedDescription) }
            }
        }
    }
    
    func preloadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        onImagePreloaded?(image)
                    }
                }
            } catch {
                
            }
        }
    }
    
    private func decrementOperations() {
        pendiongOperations -= 1
        if pendiongOperations == 0 {
            onSaveComplete?()
        }
    }
}
