import FirebaseFirestore

struct Quiz: Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let order: Int
    let questionCount: Int
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let title = data["title"] as? String,
            let imageUrl = data["imageUrl"] as? String,
            let order = data["order"] as? Int,
            let questionCount = data["questionCount"] as? Int
        else {
            return nil
        }
        
        self.id = document.documentID
        self.title = title
        self.imageUrl = imageUrl
        self.order = order
        self.questionCount = questionCount
    }
}

struct QuizQuestion: Identifiable {
    let id: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let order: Int
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let question = data["question"] as? String,
            let correctAnswer = data["correctAnswer"] as? String,
            let incorrectAnswers = data["incorrectAnswers"] as? [String],
            let order = data["order"] as? Int
        else {
            return nil
        }
        
        self.id = document.documentID
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.order = order
    }
    
    var shuffledAnswers: [String] {
        var allAnswers = incorrectAnswers
        allAnswers.append(correctAnswer)
        return allAnswers.shuffled()
    }
    
    func isCorrectAnswer(_ answer: String) -> Bool {
        answer == correctAnswer
    }
}
