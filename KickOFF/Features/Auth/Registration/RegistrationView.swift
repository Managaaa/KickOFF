import SwiftUI

struct RegistrationView: View {
    //MARK: - Properties
    @StateObject var viewModel: RegistrationViewModel
    @State private var showErrorAlert = false
    
    let onLogin: () -> Void
    let onSuccess: (() -> Void)?
    
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
                    
                    VStack(alignment: .leading, spacing: 50) {
                        Text("რეგისტრაცია")
                            .font(FontType.black.swiftUIFont(size: 20))
                            .foregroundStyle(.white)
                        
                        VStack(spacing: 75) {
                            VStack(spacing: 60) {
                                ReusableTextField(
                                    placeholder: "სახელი*",
                                    isSecure: false,
                                    text: $viewModel.name,
                                    errorMessage: viewModel.nameError,
                                    showError: viewModel.nameError != nil
                                )
                                .onChange(of: viewModel.name) {
                                    viewModel.validateUserName()
                                }
                                
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
                                    isSecure: true,
                                    text: $viewModel.password,
                                    errorMessage: viewModel.passwordError,
                                    showError: viewModel.passwordError != nil
                                )
                                .onChange(of: viewModel.password) {
                                    viewModel.validatePassword()
                                }
                                
                                ReusableTextField(
                                    placeholder: "დააზუსტე პაროლი*",
                                                  isSecure: true,
                                    text: $viewModel.confirmPassword,
                                    errorMessage: viewModel.confirmPasswordError,
                                    showError: viewModel.confirmPasswordError != nil
                                )
                                .onChange(of: viewModel.confirmPassword) {
                                    viewModel.validateConfirmPassword()
                                }
                            }
                            
                            ReusableMainButton(title: "რეგისტრაცია", action: {
                                viewModel.validateAll()
                                viewModel.register(name: viewModel.name, email: viewModel.email, password: viewModel.password, confirmPassword: viewModel.confirmPassword)
                                if viewModel.nameError == nil && viewModel.emailError == nil && viewModel.passwordError == nil && viewModel.confirmPasswordError == nil {
                                    onLogin()
                                }
                            })
                            
                            VStack(spacing: 30) {
                                orBorderView()
                                GoogleAndFacebookSignUp(onGoogleTapped: {
                                    viewModel.signInWithGoogle()
                                }, onFacebookTapped: {})
                                
                                HStack(spacing: 3) {
                                    Text("უკვე გაქვს ანგარიში?")
                                        .font(FontType.medium.swiftUIFont(size: 12))
                                        .foregroundStyle(.white)
                                    Button {
                                        onLogin()
                                    } label: {
                                        Text("ავტორიზაცია")
                                            .font(FontType.bold.swiftUIFont(size: 12))
                                            .foregroundStyle(.customGreen)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
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
        viewModel.onSuccess = {
            onSuccess?()
        }
    }
}

#Preview {
    RegistrationView(viewModel: RegistrationViewModel(), onLogin: {}, onSuccess: nil)
}
