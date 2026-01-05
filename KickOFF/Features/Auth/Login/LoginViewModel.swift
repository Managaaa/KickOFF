import Foundation
import Combine

class LoginViewModel: ObservableObject {
    //MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var errorMessage: String? = nil
    
    var onLoginSuccess: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private let authService: FirebaseAuthService
    
    //MARK: - Init
    init(authService: FirebaseAuthService = .shared) {
        self.authService = authService
    }
    
    //MARK: - Computed Properties
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isPasswordValid: Bool {
        password.count > 8
    }
    
    //MARK: - Validations
    func validateEmail() {
        if !isEmailValid {
            emailError = ValidationError.invalidEmail.message
        } else {
            emailError = nil
        }
    }
    
    func validatePassword() {
        if !isPasswordValid {
            passwordError = ValidationError.invalidPassword.message
        } else {
            passwordError = nil
        }
    }
    
    func validateAll() {
        validateEmail()
        validatePassword()
    }
    
    func login(email: String, password: String) {
        onLoadingStateChanged?(true)
        
        Task {
            do {
                _ = try await authService.login(email: email, password: password)
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.onLoginSuccess?()
                }
            } catch {
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.handleAuthError(error)
                }
            }
        }
    }
    
    private func handleAuthError(_ error: Error) {
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else {
            errorMessage = "Failure"
        }
    }
}
