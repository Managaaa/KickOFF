import SwiftUI

struct SearchArticleRow: View {
    let article: Article
    let timeAgo: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KingfisherImageLoader.profilePicture(
                imageUrl: article.profileImageUrl.isEmpty ? nil : article.profileImageUrl,
                size: 44,
                placeholder: Image("pfp")
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(article.senderName)
                    .font(FontType.medium.swiftUIFont(size: 12))
                    .foregroundStyle(.customGreen)
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
