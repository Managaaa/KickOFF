import Foundation
import Combine
import UIKit

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
    
    func signInWithGoogle() {
        guard let rootViewController = getRootViewController() else { return }
        
        onLoadingStateChanged?(true)
        
        Task {
            do {
                _ = try await authService.signInWithGoogle(presentingViewController: rootViewController)
                
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
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = window.rootViewController else {
            return nil
        }
        return rootViewController
    }
    
    private func handleAuthError(_ error: Error) {
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else {
            errorMessage = "ცადეთ თავიდან"
        }
    }
}
