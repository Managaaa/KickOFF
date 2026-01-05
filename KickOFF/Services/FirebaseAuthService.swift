import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func register(name: String, email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            
            try await
            db.collection("users").document(authResult.user.uid)
                .setData([
                    "name": name,
                    "email": email,
                    "createdAt": FieldValue.serverTimestamp()
                ])
            
            let doc = try await
            db.collection("users").document(authResult.user.uid)
                .getDocument()
            let user = try doc.data(as: User.self)
            return user
        } catch {
            throw AuthError.from(error)
        }
    }
    
    func login(email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let doc = try await
            db.collection("users").document(authResult.user.uid)
                .getDocument()
            
            if !doc.exists {
                try await
                db.collection("users").document(authResult.user.uid)
                    .setData([
                        "name": authResult.user.email?.components(separatedBy: "@").first ?? "user",
                        "email": authResult.user.email ?? "unknown@example.com",
                        "createdAt": FieldValue.serverTimestamp()
                    ])
                
                let newDoc = try await
                db.collection("users").document(authResult.user.uid)
                    .getDocument()
                return try newDoc.data(as: User.self)
            }
            let user = try doc.data(as: User.self)
            return user
        } catch {
            throw AuthError.from(error)
        }
    }
    
    func logOut() throws {
        try auth.signOut()
    }
}
