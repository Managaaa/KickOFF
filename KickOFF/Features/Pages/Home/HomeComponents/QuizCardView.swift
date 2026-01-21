import SwiftUI

struct QuizCardView: View {
    let quiz: Quiz
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customGray
                .frame(height: 300)
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 12) {
                
                KingfisherImageLoader.news(imageUrl: quiz.imageUrl, width: nil, height: 180, cornerRadius: 10, placeholder: Image(systemName: "photo"))
                    .frame(height: 180)
                    .clipped()
                
                Text("ქვიზი")
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundColor(.customGreen)
                
                Text(quiz.title)
                    .font(FontType.medium.swiftUIFont(size: 16))
                    .foregroundColor(.white)
            }
            .padding(12)
        }
    }
}

