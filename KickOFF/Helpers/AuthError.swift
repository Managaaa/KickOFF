import Foundation
import FirebaseAuth

enum AuthError: Error {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case userNotFound
    case wrongPassword
    case invalidEmail
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "არასწორი მეილი ან პაროლი"
        case .emailAlreadyInUse:
            return "მეილი უკვე გამოყენებულია"
        case .weakPassword:
            return "სუსტი პაროლი. გამოიყენეთ მინიმუმ 8 სიმბოლო"
        case .networkError:
            return "კავშირის შეცდომა. ცადე თავიდან"
        case .userNotFound:
            return "მსგავსი მეილით ანგარიში ვერ მოიძებნა"
        case .wrongPassword:
            return "არასწორი პაროლი"
        case .invalidEmail:
            return "არასწორი მეილის ფორმატი"
        case .unknown(let message):
            return message
        }
    }
    
    static func from(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .wrongPassword:
                return .wrongPassword
            case .userNotFound:
                return .userNotFound
            case .invalidEmail:
                return .invalidEmail
            case .invalidCredential:
                return .invalidCredentials
            case .emailAlreadyInUse:
                return .emailAlreadyInUse
            case .weakPassword:
                return .weakPassword
            case .networkError:
                return .networkError
            default:
                return .unknown(error.localizedDescription)
            }
        }
        
        return .unknown(error.localizedDescription)
    }
}
