import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit

protocol AuthServiceProtocol: AnyObject {
    func register(name: String, email: String, password: String) async throws -> User
    func login(email: String, password: String) async throws -> User
    func signInWithGoogle(presentingViewController: UIViewController) async throws -> User
    func logOut() throws
    func updateProfile(name: String, email: String) async throws
    func updateProfileImage(imageUrl: String) async throws
    func getCurrentUser() async throws -> User?
}

final class FirebaseAuthService: AuthServiceProtocol {
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
    
    func signInWithGoogle(presentingViewController: UIViewController) async throws -> User {
        guard let clientID = auth.app?.options.clientID else {
            throw NSError(domain: "FirebaseAuthService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Missing cliend ID"])
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "FirebaseAuthService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Missing ID token"])
        }
        
        let accessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        let authResult = try await auth.signIn(with: credential)
        let userDoc = try await db.collection("users").document(authResult.user.uid).getDocument()
        
        if !userDoc.exists {
            let email = authResult.user.email ?? ""
            let displayName = authResult.user.displayName ?? "User"
            let username = email.components(separatedBy: "@").first ?? "user"
            
            try await db.collection("users").document(authResult.user.uid)
                .setData([
                    "name": displayName,
                    "username": username,
                    "email": email,
                    "createdAt": FieldValue.serverTimestamp()
                ])
            
            let newDoc = try await db.collection("users").document(authResult.user.uid).getDocument()
            return try newDoc.data(as: User.self)
        }
        
        return try userDoc.data(as: User.self)
    }
    
    func logOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try auth.signOut()
    }
    
    func updateProfile(name: String, email: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        let updates: [String: Any] = [
            "name": name,
            "email": email,
            "updatedAd": Timestamp()
        ]
        
        try await
        db.collection("users").document(uid)
            .updateData(updates)
    }
    
    func updateProfileImage(imageUrl: String) async throws {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "FirebaseAuthService", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        try await
        db.collection("users").document(uid).updateData(["profileImageUrl" : imageUrl])
    }
    
    func getCurrentUser() async throws -> User? {
        guard let uid = auth.currentUser?.uid else { return nil }
        let doc = try await db.collection("users").document(uid).getDocument()
        return try doc.data(as: User.self)
    }
}
