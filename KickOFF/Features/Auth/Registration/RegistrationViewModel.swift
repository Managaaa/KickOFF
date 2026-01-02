import Foundation
import Combine

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
            nameError = AuthError.emptyName.message
        } else {
            nameError = nil
        }
    }
    
    func validateEmail() {
        if !isEmailValid {
            emailError = AuthError.invalidEmail.message
        } else {
            emailError = nil
        }
    }
    
    func validatePassword() {
        if !isPasswordValid {
            passwordError = AuthError.invalidPassword.message
        } else {
            passwordError = nil
        }
    }
    
    func validateConfirmPassword() {
        if !isConfirmPasswordValid {
            confirmPasswordError = AuthError.passwordsDoNotMatch.message
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
}
