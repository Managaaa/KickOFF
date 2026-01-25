import SwiftUI

struct QuizView: View {
    let quiz: Quiz
    var onQuizTap: ((Quiz) -> Void)?
    var onStartQuiz: ((Quiz) -> Void)?
    @StateObject var viewModel: HomeViewModel
    @State private var startButtonTitle: String = "დაიწყე ქვიზი"
    
    init(viewModel: HomeViewModel, quiz: Quiz, onQuizTap: ((Quiz) -> Void)? = nil, onStartQuiz: ((Quiz) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.quiz = quiz
        self.onQuizTap = onQuizTap
        self.onStartQuiz = onStartQuiz
    }
    
    var recomendationQuizzes: [Quiz] {
        viewModel.quizzes.filter { quizItem in
            quizItem.id != quiz.id
        }
    }
    
    private func updateStartButtonTitle() {
        let ids = UserDefaults.standard.stringArray(forKey: "quizProgress_questionIds_\(quiz.id)") ?? []
        guard !ids.isEmpty else {
            startButtonTitle = "დაიწყე ქვიზი"
            return
        }
        let index = UserDefaults.standard.integer(forKey: "quizProgress_currentIndex_\(quiz.id)")
        startButtonTitle = index >= 1 ? "განაგრძე ქვიზი" : "დაიწყე ქვიზი"
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ქვიზები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        GeometryReader { geometry in
                            KingfisherImageLoader.news(
                                imageUrl: quiz.imageUrl,
                                width: geometry.size.width,
                                height: 240,
                                cornerRadius: 10,
                                placeholder: Image(systemName: "photo")
                            )
                        }
                        .frame(height: 240)
                        .clipped()
                        
                        Text("ქვიზი")
                            .font(FontType.medium.swiftUIFont(size: 16))
                            .foregroundStyle(.customGreen)
                    
                        VStack(alignment: .leading, spacing: 20) {
                            Text(quiz.title)
                                .font(FontType.bold.swiftUIFont(size: 16))
                                .foregroundStyle(.white)
                                .padding(.bottom, 20)
                        
                            HStack {
                                Spacer()
                                ReusableMainButton(title: startButtonTitle, action: {
                                    onStartQuiz?(quiz)
                                })
                                Spacer()
                            }
                            .padding(.bottom, 30)
                        
                            VStack(alignment: .leading, spacing: 20) {
                                Text("რეკომენდაციები")
                                    .font(FontType.black.swiftUIFont(size: 20))
                                    .foregroundStyle(.white)
                            }
                            
                            ForEach(recomendationQuizzes) { quizItem in
                                QuizCardView(quiz: quizItem)
                                    .onTapGesture {
                                        onQuizTap?(quizItem)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            updateStartButtonTitle()
        }
        .onReceive(NotificationCenter.default.publisher(for: .quizProgressDidSave)) { notification in
            guard (notification.userInfo?["quizId"] as? String) == quiz.id else { return }
            updateStartButtonTitle()
        }
    }
}
