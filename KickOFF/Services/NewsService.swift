import FirebaseFirestore

final class NewsService {
    
    private let db = Firestore.firestore()
    
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
}
