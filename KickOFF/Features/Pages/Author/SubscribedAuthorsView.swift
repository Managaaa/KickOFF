import SwiftUI

struct SubscribedAuthorsView: View {
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 0) {
                    Text("გამოწერილი")
                        .font(FontType.black.swiftUIFont(size: 20))
                        .foregroundStyle(.white)
                    Text("ავტორები")
                        .font(FontType.black.swiftUIFont(size: 20))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 70)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }
}
