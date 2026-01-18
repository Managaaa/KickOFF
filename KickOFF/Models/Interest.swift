import FirebaseFirestore

struct Interest: Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    
    init(id: String, title: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let title = data["title"] as? String,
            let imageUrl = data["imageUrl"] as? String
        else {
            return nil
        }
        
        self.id = document.documentID
        self.title = title
        self.imageUrl = imageUrl
    }
}
