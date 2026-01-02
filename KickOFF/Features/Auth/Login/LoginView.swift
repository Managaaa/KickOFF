import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    let onLoginSuccess: () -> Void
    let onRegister: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customBackground
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                Image(.logo)
                    .resizable()
                    .frame(width: 150, height: 20)
                
                VStack(alignment: .leading, spacing: 100) {
                    Text("ავტორიზაცია")
                        .font(.custom("TBCContracticaCAPS-Black", size: 20))
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 75) {
                        VStack(spacing: 60) {
                            ReusableTextField(placeholder: "ელფოსტა*", isSecure: false, text: $viewModel.email)
                            ReusableTextField(placeholder: "პაროლი*", isSecure: true, text: $viewModel.password)
                        }
                        ReusableMainButton(title: "ავტორიზაცია", action: onLoginSuccess)
                        VStack(spacing: 30) {
                            orBorderView()
                            GoogleAndAppleSignUp(onGoogleTapped: {}, onAppleTapped: {})
                            
                            HStack(spacing: 3) {
                                Text("არ გაქვს ანგარიში?")
                                    .font(.custom("TBCContracticaCAPS-Medium", size: 12))
                                    .foregroundStyle(.white)
                                Button {
                                    onRegister()
                                } label: {
                                    Text("რეგისტრაცია")
                                        .font(.custom("TBCContracticaCAPS-Bold", size: 12))
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
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(), onLoginSuccess: {} , onRegister:  {})
}
