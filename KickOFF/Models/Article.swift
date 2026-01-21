import FirebaseFirestore

struct Article: Identifiable {
    let id: String
    let title: String
    let text: String
    let senderId: String
    let senderName: String
    let profileImageUrl: String
    let timestamp: Date
    let likes: Int
    let likedBy: [String]

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let title = data["title"] as? String,
            let text = data["text"] as? String,
            let senderId = data["senderId"] as? String,
            let senderName = data["senderName"] as? String,
            let profileImageUrl = data["profileImageUrl"] as? String,
            let timestamp = data["timestamp"] as? Timestamp,
            let likes = data["likes"] as? Int
        else {
            return nil
        }

        self.id = document.documentID
        self.title = title
        self.text = text
        self.senderId = senderId
        self.senderName = senderName
        self.profileImageUrl = profileImageUrl
        self.timestamp = timestamp.dateValue()
        self.likes = likes
        self.likedBy = data["likedBy"] as? [String] ?? []
    }
}

