import SwiftUI

struct SubscribedAuthorCardView: View {
    let author: Author
    
    var body: some View {
        ZStack {
            Color.customGray
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 0.5)
                )
            
            HStack(spacing: 16) {
                if let imageUrl = author.profileImageUrl {
                    KingfisherImageLoader.profilePicture(
                        imageUrl: imageUrl,
                        size: 60,
                        placeholder: Image("pfp")
                    )
                } else {
                    Image("pfp")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(author.name)
                        .font(FontType.bold.swiftUIFont(size: 16))
                        .foregroundStyle(.white)
                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(.heart)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                            
                            Text("\(author.totalLikes) მოწონება")
                                .font(FontType.medium.swiftUIFont(size: 10))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        HStack(spacing: 6) {
                            Image(.subscribers)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                            
                            Text("\(author.subscribers) გამომწერი")
                                .font(FontType.medium.swiftUIFont(size: 10))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .frame(height: 120)
        .cornerRadius(10)
    }
}
