import SwiftUI

struct GoogleAndFacebookSignUp: View {
    var onGoogleTapped: () -> Void
    var onFacebookTapped: () -> Void
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
                onFacebookTapped()
            } label: {
//                Image(.fb)
//                    .resizable()
//                    .frame(width: 40, height: 40) //TODO: remove or implement any auth here
            }
        }
    }
}
