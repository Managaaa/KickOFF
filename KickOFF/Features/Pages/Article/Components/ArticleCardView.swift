import SwiftUI

struct ArticleCardView: View {
    let authorName: String
    let authorProfileImageUrl: String?
    let title: String
    let date: String

    init(
        authorName: String,
        authorProfileImageUrl: String? = nil,
        title: String,
        date: String
    ) {
        self.authorName = authorName
        self.authorProfileImageUrl = authorProfileImageUrl
        self.title = title
        self.date = date
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customGray
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    KingfisherImageLoader.profilePicture(
                        imageUrl: authorProfileImageUrl,
                        size: 28,
                        placeholder: Image("pfp")
                    )

                    Text(authorName)
                        .font(FontType.medium.swiftUIFont(size: 12))
                        .foregroundStyle(.customGreen)

                    Spacer()
                }

                Text(title)
                    .font(FontType.medium.swiftUIFont(size: 13))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(date)
                    .font(FontType.light.swiftUIFont(size: 10))
                    .foregroundStyle(.white.opacity(0.9))
                
                Button {
                    //TODO: - article like actin
                } label: {
                    Image(.heart)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
    }
}

