import Foundation

class ProfileViewModel {
    private let authService: FirebaseAuthService
    
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
}
