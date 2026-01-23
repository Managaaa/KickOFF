import FirebaseFirestore
import FirebaseAuth
import Foundation

final class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    private let articleService = ArticleService.shared
    
    private init() {}
    
    func fetchAuthorsWithArticles() async throws -> [Author] {
        let articles = try await articleService.fetchArticles()
        
        let currentUserId = Auth.auth().currentUser?.uid
        
        let articlesByAuthor = Dictionary(grouping: articles) { $0.senderId }
        
        var authors: [Author] = []
        
        for (userId, userArticles) in articlesByAuthor {
            guard !userArticles.isEmpty else { continue }
            
            if let currentUserId = currentUserId, userId == currentUserId {
                continue
            }
            
            let totalLikes = userArticles.reduce(0) { $0 + $1.likes }
            
            let userDoc = try? await db.collection("users").document(userId).getDocument()
            let user = try? userDoc?.data(as: User.self)
            
            let subscribers = user?.subscribers ?? 0
            
            let profileImage = user?.profileImageUrl ?? userArticles.first?.profileImageUrl
            
            let author = Author(
                userId: userId,
                name: user?.name ?? userArticles.first?.senderName ?? "Unknown",
                profileImageUrl: profileImage,
                totalLikes: totalLikes,
                subscribers: subscribers,
                articleCount: userArticles.count
            )
            
            authors.append(author)
        }
        
        return authors.sorted { $0.totalLikes > $1.totalLikes }
    }
    
    func subscribeToUser(authorId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "UserService", code: -1, 
                        userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        guard currentUserId != authorId else {
            return
        }
        
        let userRef = db.collection("users").document(authorId)
        
        let currentUserDoc = try await db.collection("users").document(currentUserId).getDocument()
        let subscribedTo = (try? currentUserDoc.data(as: User.self).subscribedTo) ?? []
        
        if subscribedTo.contains(authorId) {
            return
        }
        
        try await db.collection("users").document(currentUserId).updateData([
            "subscribedTo": FieldValue.arrayUnion([authorId])
        ])
        
        try await userRef.updateData([
            "subscribers": FieldValue.increment(Int64(1))
        ])
    }
    
    func unsubscribeFromUser(authorId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "UserService", code: -1, 
                        userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        guard currentUserId != authorId else {
            return
        }
        
        let userRef = db.collection("users").document(authorId)
        
        let currentUserDoc = try await db.collection("users").document(currentUserId).getDocument()
        let subscribedTo = (try? currentUserDoc.data(as: User.self).subscribedTo) ?? []
        
        if !subscribedTo.contains(authorId) {
            return
        }
        
        try await db.collection("users").document(currentUserId).updateData([
            "subscribedTo": FieldValue.arrayRemove([authorId])
        ])
        
        try await userRef.updateData([
            "subscribers": FieldValue.increment(Int64(-1))
        ])
    }
    
    func isSubscribedTo(authorId: String) async throws -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return false
        }
        
        let userDoc = try await db.collection("users").document(currentUserId).getDocument()
        let user = try? userDoc.data(as: User.self)
        return user?.subscribedTo?.contains(authorId) ?? false
    }
}

