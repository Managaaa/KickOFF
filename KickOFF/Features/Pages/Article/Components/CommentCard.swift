import SwiftUI

struct CommentCard: View {
    let comment: Comment
    let timeAgo: String
    var canDelete: Bool = false
    var isDeleteDisabled: Bool = false
    var onDelete: (() -> Void)?

    var body: some View {
        ZStack(alignment: .leading) {
            Color.clear
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 0.3)
                )
            HStack(alignment: .top, spacing: 12) {
                KingfisherImageLoader.profilePicture(
                    imageUrl: (comment.profileImageUrl ?? "").isEmpty ? nil : comment.profileImageUrl,
                    size: 32,
                    placeholder: Image("pfp")
                )
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(comment.senderName)
                            .font(FontType.medium.swiftUIFont(size: 12))
                            .foregroundStyle(.customGreen)
                        Text(timeAgo)
                            .font(FontType.light.swiftUIFont(size: 10))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    Text(comment.text)
                        .font(FontType.medium.swiftUIFont(size: 13))
                        .foregroundStyle(.white)
                }

                Spacer()

                if canDelete {
                    VStack {
                        Spacer()
                        Button {
                            onDelete?()
                        } label: {
                            Image("delete")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .disabled(isDeleteDisabled)
                        Spacer()
                    }
                }
            }
            .padding(12)
        }
    }
}
