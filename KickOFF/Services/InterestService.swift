import FirebaseFirestore

final class InterestService {
    private let db = Firestore.firestore()

    func fetchInterests() async -> [Interest] {
        await withCheckedContinuation { continuation in
            db.collection("interests")
                .getDocuments { snapshot, error in
                    
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let interests = documents.compactMap { Interest(document: $0) }
                    continuation.resume(returning: interests)
                }
        }
    }
}
