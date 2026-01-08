import Foundation

class ProfileViewModel {
    private let authService: FirebaseAuthService
    private var currentUser: User?
    
    var onError: ((String) -> Void)?
    var onUserLoaded: ((User) -> Void)?
    
    var onLogoutSuccess: (() -> Void)?
    var onLogoutError: ((String) -> Void)?
    
    init(authService: FirebaseAuthService = .shared) {
        self.authService = authService
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
}
