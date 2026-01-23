import Combine
import Foundation

extension Notification.Name {
    static let quizProgressDidSave = Notification.Name("quizProgressDidSave")
}

class QuizDetailsViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: String? = nil
    @Published var showResult: Bool = false
    @Published var isLoading: Bool = false
    
    private var shuffledAnswersForQuestions: [String: [String]] = [:]
    private let quizService: QuizService
    private let quizId: String
    private var hasCompletedQuiz: Bool = false
    
    private var questionIdsKey: String { "quizProgress_questionIds_\(quizId)" }
    private var currentIndexKey: String { "quizProgress_currentIndex_\(quizId)" }
    
    init(quizId: String, quizService: QuizService = QuizService()) {
        self.quizId = quizId
        self.quizService = quizService
        fetchQuestions()
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progressText: String {
        "\(currentQuestionIndex + 1)/\(questions.count)"
    }
    
    var shuffledAnswers: [String] {
        guard let question = currentQuestion else { return [] }
        if let cached = shuffledAnswersForQuestions[question.id] {
            return cached
        }
        let shuffled = question.shuffledAnswers
        shuffledAnswersForQuestions[question.id] = shuffled
        return shuffled
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    func fetchQuestions() {
        isLoading = true
        
        Task { [weak self] in
            guard let self = self else { return }
            let fetched = await self.quizService.fetchQuestions(for: self.quizId)
            
            await MainActor.run {
                let savedIds = UserDefaults.standard.stringArray(forKey: self.questionIdsKey) ?? []
                let savedIndex = UserDefaults.standard.integer(forKey: self.currentIndexKey)
                
                var ordered: [QuizQuestion] = []
                if !savedIds.isEmpty {
                    for id in savedIds {
                        if let q = fetched.first(where: { $0.id == id }) {
                            ordered.append(q)
                        }
                    }
                    for q in fetched where !savedIds.contains(q.id) {
                        ordered.append(q)
                    }
                }
                if ordered.isEmpty {
                    ordered = fetched.shuffled()
                }
                
                self.questions = ordered
                self.currentQuestionIndex = min(max(0, savedIndex), max(0, self.questions.count - 1))
                
                for question in self.questions {
                    if self.shuffledAnswersForQuestions[question.id] == nil {
                        self.shuffledAnswersForQuestions[question.id] = question.shuffledAnswers
                    }
                }
                self.isLoading = false
            }
        }
    }
    
    func saveProgress() {
        guard !hasCompletedQuiz, !questions.isEmpty else { return }
        UserDefaults.standard.set(questions.map(\.id), forKey: questionIdsKey)
        UserDefaults.standard.set(currentQuestionIndex, forKey: currentIndexKey)
        NotificationCenter.default.post(name: .quizProgressDidSave, object: nil, userInfo: ["quizId": quizId])
    }
    
    func clearProgress() {
        UserDefaults.standard.removeObject(forKey: questionIdsKey)
        UserDefaults.standard.removeObject(forKey: currentIndexKey)
        NotificationCenter.default.post(name: .quizProgressDidSave, object: nil, userInfo: ["quizId": quizId])
    }
    
    func markAsCompleted() {
        hasCompletedQuiz = true
        clearProgress()
    }
    
    func selectAnswer(_ answer: String) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = answer
        showResult = true
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showResult = false
            saveProgress()
        }
    }
    
    func isCorrectAnswer(_ answer: String) -> Bool {
        currentQuestion?.isCorrectAnswer(answer) ?? false
    }
    
    func isSelectedAnswer(_ answer: String) -> Bool {
        selectedAnswer == answer
    }
}
