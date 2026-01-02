import Foundation
import Combine

class LoginViewModel: ObservableObject {
    //MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
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
    
    func validateAll() {
        validateEmail()
        validatePassword()
    }
}
