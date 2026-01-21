import FirebaseFirestore

final class QuizService {
    
    private let db = Firestore.firestore()
    
    func fetchQuizzes() async -> [Quiz] {
        await withCheckedContinuation { continuation in
            db.collection("quizzes")
                .order(by: "order", descending: false)
                .getDocuments { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let quizzes = documents.compactMap { Quiz(document: $0) }
                    continuation.resume(returning: quizzes)
                }
        }
    }
    
    func fetchQuestions(for quizId: String) async -> [QuizQuestion] {
        await withCheckedContinuation { continuation in
            db.collection("quizzes")
                .document(quizId)
                .collection("questions")
                .order(by: "order", descending: false)
                .getDocuments { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let questions = documents.compactMap { QuizQuestion(document: $0) }
                    continuation.resume(returning: questions)
                }
        }
    }
}
