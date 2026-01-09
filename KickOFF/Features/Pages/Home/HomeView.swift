import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customBackground
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Best Of 2025")
                        .foregroundStyle(.white)
                        .font(FontType.black.swiftUIFont(size: 20))
                    
                    Text("2025 წლის გამორჩეული ამბები")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(FontType.medium.swiftUIFont(size: 12))
                    
                    BestOfsCardView()
                }
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("ახალი ამბები")
                        .foregroundStyle(.white)
                        .font(FontType.black.swiftUIFont(size: 20))
                    
                    Text("გაეცანი მსოფლიო სპორტის სიახლეებს")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(FontType.medium.swiftUIFont(size: 12))
                    
                    NewsCardView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 30)
        }
    }
}

#Preview {
    HomeView()
}
