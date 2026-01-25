import SwiftUI

struct ArticleWriteView: View {
    @StateObject private var viewModel: ArticleViewModel

    init(viewModel: ArticleViewModel, onFinish: (() -> Void)? = nil) {
        viewModel.onSuccess = onFinish
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("გააზიარე შენი სპორტული ფიქრები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)

                ArticleTitleTextFieldView(text: $viewModel.title)
                    .padding(.horizontal, 16)

                ArticleBodyTextEditorView(text: $viewModel.body)
                    .padding(.horizontal, 16)

                ReusableMainButton(title: "გააზიარე", action: {
                    Task {
                        await viewModel.share()
                    }
                })
            }
            .padding(.bottom, 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
        .alert(Text(viewModel.alertTitle), isPresented: $viewModel.isAlertPresented) {
            Button("კარგი", role: .cancel) {
                viewModel.handleAlertOKTap()
            }
        } message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }
    }
}

#Preview {
    ArticleWriteView(viewModel: ArticleViewModel())
}
