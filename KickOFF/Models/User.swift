import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let createdAt: Date
    let profileImageUrl: String?
    let interestIds: [String]?
    let favoriteNews: [String]?
    let subscribers: Int?
    let subscribedTo: [String]?
    
    init(id: String? = nil, name: String, email: String, createdAt: Date = Date(), profileImageUrl: String? = nil, interestIds: [String]? = nil, favoriteNews: [String]? = nil, subscribers: Int? = nil, subscribedTo: [String]? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
        self.profileImageUrl = profileImageUrl
        self.interestIds = interestIds
        self.favoriteNews = favoriteNews
        self.subscribers = subscribers
        self.subscribedTo = subscribedTo
    }
}
