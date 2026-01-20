import FirebaseFirestore
import FirebaseAuth

final class NewsService {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func fetchBestOfNews() async -> [BestOfNews] {
        await withCheckedContinuation { continuation in
            db.collection("bestofnews")
                .order(by: "date", descending: true)
                .getDocuments { snapshot, error in
                    
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let bestOfNews = documents.compactMap { BestOfNews(document: $0) }
                    continuation.resume(returning: bestOfNews)
                }
        }
    }
    
    
    func fetchNews(limit: Int? = nil) async -> [News] {
        await withCheckedContinuation { continuation in
            let query: Query = {
                let baseQuery = db.collection("news")
                    .order(by: "date", descending: true)
                
                if let limit = limit {
                    return baseQuery.limit(to: limit)
                } else {
                    return baseQuery
                }
            }()
            
            query.getDocuments { snapshot, error in
                    
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let news = documents.compactMap { News(document: $0)}
                    continuation.resume(returning: news)
                }
        }
    }
    
    func addFavoriteNews(newsId: String) async throws {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "NewsService", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let userRef = db.collection("users").document(uid)
        let userDoc = try await userRef.getDocument()
        
        var favoriteNews = (userDoc.data()?["favoriteNews"] as? [String]) ?? []
        if !favoriteNews.contains(newsId) {
            favoriteNews.append(newsId)
            try await userRef.updateData(["favoriteNews": favoriteNews])
        }
    }
    
    func removeFavoriteNews(newsId: String) async throws {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "NewsService", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let userRef = db.collection("users").document(uid)
        let userDoc = try await userRef.getDocument()
        
        var favoriteNews = (userDoc.data()?["favoriteNews"] as? [String]) ?? []
        favoriteNews.removeAll { $0 == newsId }
        try await userRef.updateData(["favoriteNews": favoriteNews])
    }
}
