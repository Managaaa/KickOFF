import FirebaseFirestore

struct BestOfNews: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let date: Date
    let text: String
    let imageUrl: String

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let title = data["title"] as? String,
            let subtitle = data["subtitle"] as? String,
            let timestamp = data["date"] as? Timestamp,
            let text = data["text"] as? String,
            let imageUrl = data["imageUrl"] as? String
        else {
            return nil
        }

        self.id = document.documentID
        self.title = title
        self.subtitle = subtitle
        self.date = timestamp.dateValue()
        self.text = text
        self.imageUrl = imageUrl
    }
}
