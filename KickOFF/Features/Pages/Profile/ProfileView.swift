import SwiftUI

struct ProfileView: View {
    var onLogin: () -> Void
    var body: some View {
        Button {
            onLogin()
        } label: {
            Text("Back To Login")
        }
    }
}
