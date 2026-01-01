import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    let onLogin: () -> Void
    
    var body: some View {
        Button {
            onLogin()
        } label: {
            Text("Go To Login")
        }
    }
}
