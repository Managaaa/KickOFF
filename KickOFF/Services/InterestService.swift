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
    
    func addUserInterest(uid: String, interestId: String) async throws {
        try await db.collection("users").document(uid).updateData([
            "interestIds": FieldValue.arrayUnion([interestId])
        ])
    }
    
    func removeUserInterest(uid: String, interestId: String) async throws {
        try await db.collection("users").document(uid).updateData([
            "interestIds": FieldValue.arrayRemove([interestId])
        ])
    }
}
