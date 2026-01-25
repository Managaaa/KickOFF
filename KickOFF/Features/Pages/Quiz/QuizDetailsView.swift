import SwiftUI

struct QuizDetailsView: View {
    let quiz: Quiz
    var onFinish: (() -> Void)?
    @StateObject var viewModel: QuizDetailsViewModel
    
    init(quiz: Quiz, viewModel: QuizDetailsViewModel, onFinish: (() -> Void)? = nil) {
        self.quiz = quiz
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFinish = onFinish
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let currentQuestion = viewModel.currentQuestion {
                VStack(spacing: 0) {
                    Text(viewModel.progressText)
                        .font(FontType.medium.swiftUIFont(size: 16))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.question)
                            .font(FontType.medium.swiftUIFont(size: 16))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.shuffledAnswers, id: \.self) { answer in
                                AnswerOptionView(
                                    answer: answer,
                                    isSelected: viewModel.isSelectedAnswer(answer),
                                    isCorrect: viewModel.isCorrectAnswer(answer),
                                    showResult: viewModel.showResult,
                                    onTap: {
                                        viewModel.selectAnswer(answer)
                                    }
                                )
                            }
                        }
                        
                        if viewModel.showResult {
                            HStack {
                                Spacer()
                                ReusableMainButton(
                                    title: viewModel.isLastQuestion ? "დასრულება" : "შემდეგი კითხვა",
                                    action: {
                                        if viewModel.isLastQuestion {
                                            viewModel.markAsCompleted()
                                            onFinish?()
                                        } else {
                                            viewModel.nextQuestion()
                                        }
                                    }
                                )
                                Spacer()
                            }
                            .padding(.top, 24)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
            }
        }
        .onDisappear {
            viewModel.saveProgress()
        }
        .alert("ქვიზის შედეგი", isPresented: $viewModel.showQuizResultAlert) {
            Button("კარგი", role: .cancel) {
                viewModel.showQuizResultAlert = false
            }
        } message: {
            Text(viewModel.quizResultMessage)
        }
    }
}
