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
            VStack(alignment: .leading, spacing: 12) {
                
                AsyncImage(url: URL(string: image)) { phase in
                    if let loadedImage = phase.image {
                        loadedImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 180)
                            .cornerRadius(12)
                    }
                }
                .frame(height: 180)
                .clipped()
                
                Text(title)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundColor(.customGreen)
                
                Text(subtitle)
                    .font(FontType.medium.swiftUIFont(size: 16))
                    .foregroundColor(.white)
            }
            .padding(12)
        }
    }
}

#Preview {
    HomeView()
}
