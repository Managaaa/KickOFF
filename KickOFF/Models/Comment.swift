import FirebaseFirestore

struct Comment: Identifiable {
    let id: String
    let articleId: String
    let senderId: String
    let senderName: String
    let profileImageUrl: String?
    let text: String
    let timestamp: Date

    init(
        id: String,
        articleId: String,
        senderId: String,
        senderName: String,
        profileImageUrl: String?,
        text: String,
        timestamp: Date
    ) {
        self.id = id
        self.articleId = articleId
        self.senderId = senderId
        self.senderName = senderName
        self.profileImageUrl = profileImageUrl
        self.text = text
        self.timestamp = timestamp
    }

    init?(document: QueryDocumentSnapshot, articleId: String) {
        let data = document.data()
        guard
            let senderId = data["senderId"] as? String,
            let senderName = data["senderName"] as? String,
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Timestamp
        else {
            return nil
        }
        self.id = document.documentID
        self.articleId = articleId
        self.senderId = senderId
        self.senderName = senderName
        self.profileImageUrl = data["profileImageUrl"] as? String
        self.text = text
        self.timestamp = timestamp.dateValue()
    }
}
