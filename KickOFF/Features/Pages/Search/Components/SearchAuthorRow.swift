import SwiftUI

struct SearchAuthorRow: View {
    let author: Author

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KingfisherImageLoader.profilePicture(
                imageUrl: (author.profileImageUrl ?? "").isEmpty ? nil : author.profileImageUrl,
                size: 44,
                placeholder: Image("pfp")
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(author.name)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundStyle(.white)
                Text("\(author.subscribers) გამომწერი - \(author.totalLikes) მოწონება")
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
