import SwiftUI

struct GoogleAndAppleSignUp: View {
    var onGoogleTapped: () -> Void
    var onAppleTapped: () -> Void
    var body: some View {
        HStack(spacing: 20) {
            Button {
                onGoogleTapped()
            } label: {
                Image(.google)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Button {
                onAppleTapped()
            } label: {
                Image(.apple)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
    }
}
