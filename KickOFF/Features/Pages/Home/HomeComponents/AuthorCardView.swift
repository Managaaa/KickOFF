import SwiftUI

struct AuthorCardView: View {
    let author: Author
    let isSubscribed: Bool
    let onSubscribeTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.customGray
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 0.5)
                )
            
            Image("authorCover")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
            
            VStack(spacing: 0) {
                if let imageUrl = author.profileImageUrl {
                    KingfisherImageLoader.profilePicture(
                        imageUrl: imageUrl,
                        size: 80,
                        placeholder: Image("pfp")
                    )
                    .offset(y: -40)
                } else {
                    Image("pfp")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .offset(y: -40)
                }
                
                Text(author.name)
                    .font(FontType.black.swiftUIFont(size: 16))
                    .foregroundStyle(.white)
                    .padding(.top, -20)
                    .padding(.bottom, 16)
                
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image("subscribers")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("\(author.subscribers)")
                            .font(FontType.medium.swiftUIFont(size: 14))
                            .foregroundStyle(.white)
                    }
                    
                    Rectangle()
                        .fill(.white.opacity(0.6))
                        .frame(width: 1, height: 16)
                    
                    HStack(spacing: 6) {
                        Image("heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("\(author.totalLikes)")
                            .font(FontType.medium.swiftUIFont(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 20)
                
                Button {
                    onSubscribeTap()
                } label: {
                    Image(isSubscribed ? .unsubscribebutton : .subscribebutton)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: 120)
        }
        .frame(height: 320)
        .cornerRadius(10)
    }
}
