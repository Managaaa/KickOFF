import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    let onLoginSuccess: () -> Void
    let onRegister: () -> Void
    
    var body: some View {
        VStack {
            Button {
                onRegister()
            } label: {
                Text("Go To Register")
            }
            Button {
                onLoginSuccess()
            } label: {
                Text("Go To Tab Bar Pages")
            }
        }
    }
}
