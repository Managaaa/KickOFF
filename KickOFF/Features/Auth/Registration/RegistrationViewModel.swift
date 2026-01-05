import Foundation
import Combine
import Firebase

class RegistrationViewModel: ObservableObject {
    //MARK: - Properties
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var nameError: String? = nil
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    @Published var errorMessage: String? = nil
    
    var onSuccess: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private let authService: FirebaseAuthService
    
    //MARK: - Init
    init(authService: FirebaseAuthService = .shared) {
        self.authService = authService
    }
    
    //MARK: - Computed Properties
    var isNameValid: Bool {
        !name.isEmpty
    }
    
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isPasswordValid: Bool {
        password.count > 8
    }
    
    var isConfirmPasswordValid: Bool {
        password == confirmPassword && !confirmPassword.isEmpty
    }
    
    //MARK: - Validations
    func validateUserName() {
        if !isNameValid {
            nameError = ValidationError.emptyName.message
        } else {
            nameError = nil
        }
    }
    
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
    
    func validateConfirmPassword() {
        if !isConfirmPasswordValid {
            confirmPasswordError = ValidationError.passwordsDoNotMatch.message
        } else {
            confirmPasswordError = nil
        }
    }
    
    func validateAll() {
        validateUserName()
        validateEmail()
        validatePassword()
        validateConfirmPassword()
    }
    
    func register(name: String, email: String, password: String, confirmPassword: String) {
        onLoadingStateChanged?(true)
        
        Task {
            do {
                _ = try await authService.register(name: name, email: email, password: password)
                
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.onSuccess?()
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
