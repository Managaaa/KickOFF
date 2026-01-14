import Foundation

class ProfileViewModel {
    private let authService: FirebaseAuthService
    private let interestService: InterestService
    private var currentUser: User?
    
    var onError: ((String) -> Void)?
    var onUserLoaded: ((User) -> Void)?
    
    var onLogoutSuccess: (() -> Void)?
    var onLogoutError: ((String) -> Void)?
    var onInterestsLoaded: (() -> Void)?
    var isLoading: Bool = false
    
    private(set) var interests: [Interest] = []
    
    init(authService: FirebaseAuthService = .shared, interestService: InterestService = InterestService()) {
        self.authService = authService
        self.interestService = interestService
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
    
    func fetchInterests() {
        isLoading = true
        
        Task { [weak self] in
            let interests = await self?.interestService.fetchInterests() ?? []
            
            await MainActor.run {
                self?.interests = interests
                self?.isLoading = false
                self?.onInterestsLoaded?()
            }
        }
    }
}
