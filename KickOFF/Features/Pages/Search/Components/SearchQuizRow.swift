import SwiftUI

struct SearchQuizRow: View {
    let quiz: Quiz

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KingfisherImageLoader.news(imageUrl: quiz.imageUrl, width: 60, height: 60, cornerRadius: 8, placeholder: Image(systemName: "photo"))
            VStack(alignment: .leading, spacing: 4) {
                Text("ქვიზი")
                    .font(FontType.medium.swiftUIFont(size: 12))
                    .foregroundStyle(.customGreen)
                Text(quiz.title)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundStyle(.white)
                    .lineLimit(2)
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
