import FirebaseFirestore

final class ArticleService {
    static let shared = ArticleService()
    private let db = Firestore.firestore()

    private init() {}

    func createArticle(
        title: String,
        text: String,
        senderId: String,
        senderName: String,
        profileImageUrl: String
    ) async throws -> String {
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
}

