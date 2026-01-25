import SwiftUI

struct LoginView: View {
    //MARK: - Properties
    @StateObject var viewModel: LoginViewModel
    @State private var showErrorAlert = false
    
    let onLoginSuccess: () -> Void
    let onRegister: () -> Void
    
    //MARK: - Body
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    Image(.logo)
                        .resizable()
                        .frame(width: 150, height: 20)
                    
                    VStack(alignment: .leading, spacing: 100) {
                        Text("ავტორიზაცია")
                            .font(FontType.black.swiftUIFont(size: 20))
                            .foregroundStyle(.white)
                        
                        VStack(spacing: 75) {
                            VStack(spacing: 60) {
                                ReusableTextField(
                                    placeholder: "ელფოსტა*",
                                    isSecure: false,
                                    text: $viewModel.email,
                                    errorMessage: viewModel.emailError,
                                    showError: viewModel.emailError != nil
                                )
                                    .onChange(of: viewModel.email) {
                                        viewModel.validateEmail()
                                    }
                                
                                ReusableTextField(
                                    placeholder: "პაროლი*",
                                    isSecure: true, text: $viewModel.password,
                                    errorMessage: viewModel.passwordError,
                                    showError: viewModel.passwordError != nil
                                )
                                    .onChange(of: viewModel.password) {
                                        viewModel.validatePassword()
                                    }
                            }
                            
                            ReusableMainButton(title: "ავტორიზაცია", action: {
                                viewModel.validateAll()
                                if viewModel.emailError == nil && viewModel.passwordError == nil {
                                    viewModel.login(email: viewModel.email, password: viewModel.password)
                                }
                            })
                            
                            VStack(spacing: 30) {
                                orBorderView()
                                GoogleAndFacebookSignUp(onGoogleTapped: {
                                    viewModel.signInWithGoogle()
                                })
                                
                                HStack(spacing: 3) {
                                    Text("არ გაქვს ანგარიში?")
                                        .font(FontType.medium.swiftUIFont(size: 12))
                                        .foregroundStyle(.white)
                                    Button {
                                        onRegister()
                                    } label: {
                                        Text("რეგისტრაცია")
                                            .font(FontType.bold.swiftUIFont(size: 12))
                                            .foregroundStyle(.customGreen)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onAppear {
            setupCallbacks()
        }
        .alert("შეცდომა", isPresented: $showErrorAlert) {
            Button("კარგი", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
    }
    
    private func setupCallbacks() {
        viewModel.onLoginSuccess = {
            onLoginSuccess()
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(), onLoginSuccess: {} , onRegister:  {})
}
