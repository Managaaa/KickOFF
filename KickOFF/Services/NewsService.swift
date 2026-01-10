import FirebaseFirestore

final class NewsService {

    private let db = Firestore.firestore()

    func fetchBestOfNews(completion: @escaping ([BestOfNews]) -> Void) {
        db.collection("bestofnews")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let bestOfNews = documents.compactMap { BestOfNews(document: $0) }
                completion(bestOfNews)
            }
    }
}
