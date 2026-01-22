import SwiftUI

struct BestOfsCardView: View {
    let title: String
    let subtitle: String
    let image: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customGray
                .frame(height: 300)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.customGreen, lineWidth: 0.5)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                
                KingfisherImageLoader.news(imageUrl: image, width: nil, height: 180, cornerRadius: 12, placeholder: Image(systemName: "photo"))
                    .frame(height: 180)
                    .clipped()
                
                Text(title)
                    .font(FontType.medium.swiftUIFont(size: 12))
                    .foregroundColor(.customGreen)
                
                Text(subtitle)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundColor(.white)
            }
            .padding(12)
        }
    }
}

#Preview {
    HomeView()
}
