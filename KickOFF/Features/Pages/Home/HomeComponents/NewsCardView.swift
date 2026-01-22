import SwiftUI

struct NewsCardView: View {
    let title: String
    let subtitle: String
    let image: String
    let date: String
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    
    init(title: String, subtitle: String, image: String, date: String, isFavorite: Bool = false, onFavoriteTap: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.date = date
        self.isFavorite = isFavorite
        self.onFavoriteTap = onFavoriteTap
    }
    
    var body: some View {
        ZStack {
            Color.customGray
                .frame(height: 190)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.customGreen, lineWidth: 0.5)
                )
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(FontType.medium.swiftUIFont(size: 12))
                        .foregroundStyle(.customGreen)
                    
                    Text(subtitle)
                        .font(FontType.medium.swiftUIFont(size: 13))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                }
                
                Spacer()
                
                KingfisherImageLoader.news(imageUrl: image, width: 125, height: 100, cornerRadius: 10, placeholder: Image(systemName: "photo"))
                    .padding(.bottom, 50)
            }
            .padding(.top, 2)
            .padding(.horizontal, 20)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            
            HStack {
                Text(date)
                    .font(FontType.light.swiftUIFont(size: 10))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    onFavoriteTap()
                } label: {
                    Image(isFavorite ? "selectedfavorite" : "favorite")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HomeView()
}
