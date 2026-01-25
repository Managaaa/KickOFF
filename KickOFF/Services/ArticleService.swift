import FirebaseFirestore

final class ArticleService {
    static let shared = ArticleService()
    private let db = Firestore.firestore()

    private init() {}

    func createArticle(title: String, text: String, senderId: String, senderName: String, profileImageUrl: String) async throws -> String {
        let docRef = db.collection("articles").document()

        try await docRef.setData([
            "title": title,
            "text": text,
            "senderId": senderId,
            "senderName": senderName,
            "profileImageUrl": profileImageUrl,
            "timestamp": FieldValue.serverTimestamp(),
            "likes": 0,
            "likedBy": []
        ])

        return docRef.documentID
    }

    func fetchArticles() async throws -> [Article] {
        let snapshot = try await db
            .collection("articles")
            .order(by: "timestamp", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { Article(document: $0) }
    }

    func searchArticles(query: String) async throws -> [Article] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }
        let all = try await fetchArticles()
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return all.filter {
            $0.title.lowercased().contains(q) || $0.senderName.lowercased().contains(q)
        }
    }
    
    func fetchUserArticles(userId: String) async throws -> [Article] {
        do {
            let snapshot = try await db
                .collection("articles")
                .whereField("senderId", isEqualTo: userId)
                .order(by: "timestamp", descending: true)
                .getDocuments()

            return snapshot.documents.compactMap { Article(document: $0) }
        } catch {
            print(error)
            let snapshot = try await db
                .collection("articles")
                .whereField("senderId", isEqualTo: userId)
                .getDocuments()
            
            let articles = snapshot.documents.compactMap { Article(document: $0) }
            return articles.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    func likeArticle(articleId: String, userId: String) async throws {
        let articleRef = db.collection("articles").document(articleId)
        
        let doc = try await articleRef.getDocument()
        guard let data = doc.data(),
              let likedBy = data["likedBy"] as? [String] else {
            throw NSError(domain: "ArticleService", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "Failed to fetch article"])
        }
        
        if likedBy.contains(userId) {
            return
        }
        
        try await articleRef.updateData([
            "likedBy": FieldValue.arrayUnion([userId]),
            "likes": FieldValue.increment(Int64(1))
        ])
    }
    
    func unlikeArticle(articleId: String, userId: String) async throws {
        let articleRef = db.collection("articles").document(articleId)
        
        let doc = try await articleRef.getDocument()
        guard let data = doc.data(),
              let likedBy = data["likedBy"] as? [String] else {
            throw NSError(domain: "ArticleService", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "Failed to fetch article"])
        }
        
        if !likedBy.contains(userId) {
            return
        }
        
        try await articleRef.updateData([
            "likedBy": FieldValue.arrayRemove([userId]),
            "likes": FieldValue.increment(Int64(-1))
        ])
    }
    
    func deleteArticle(articleId: String) async throws {
        try await db.collection("articles").document(articleId).delete()
    }

    func fetchComments(articleId: String) async throws -> [Comment] {
        let snapshot = try await db
            .collection("articles")
            .document(articleId)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments()
        return snapshot.documents.compactMap { Comment(document: $0, articleId: articleId) }
    }

    func addComment(articleId: String, senderId: String, senderName: String, profileImageUrl: String?, text: String) async throws -> String {
        let ref = db
            .collection("articles")
            .document(articleId)
            .collection("comments")
            .document()
        try await ref.setData([
            "senderId": senderId,
            "senderName": senderName,
            "profileImageUrl": profileImageUrl ?? "",
            "text": text,
            "timestamp": FieldValue.serverTimestamp()
        ])
        return ref.documentID
    }

    func deleteComment(articleId: String, commentId: String) async throws {
        try await db
            .collection("articles")
            .document(articleId)
            .collection("comments")
            .document(commentId)
            .delete()
    }
}

