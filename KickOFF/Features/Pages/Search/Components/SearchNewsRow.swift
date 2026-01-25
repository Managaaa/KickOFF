import SwiftUI

struct SearchNewsRow: View {
    let news: News
    let timeAgo: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KingfisherImageLoader.news(imageUrl: news.imageUrl, width: 60, height: 60, cornerRadius: 8, placeholder: Image(systemName: "photo"))
            VStack(alignment: .leading, spacing: 4) {
                Text(news.title)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundStyle(.customGreen)
                    .lineLimit(1)
                Text(news.subtitle)
                    .font(FontType.medium.swiftUIFont(size: 13))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(timeAgo)
                    .font(FontType.light.swiftUIFont(size: 11))
                    .foregroundStyle(.white.opacity(0.6))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(12)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(Color.customGreen, lineWidth: 0.5)
        )
    }
}
