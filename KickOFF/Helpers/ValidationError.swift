import Foundation

enum ValidationError: String {
    case invalidEmail = "გთხოვთ შეიყვანეთ სწორი ელ ფოსტა"
    case invalidPassword = "პაროლი უნდა იყოს 8 სიმბოლოზე მეტი"
    case passwordsDoNotMatch = "პაროლები არ ემთხვევა"
    case emptyName = "სახელის ველი არ უნდა იყოს ცარიელი"
    
    var message: String {
        return self.rawValue
    }
}

