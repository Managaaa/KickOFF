import SwiftUI

struct GoogleAndFacebookSignUp: View {
    var onGoogleTapped: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button {
                onGoogleTapped()
            } label: {
                Image(.google)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
    }
}
