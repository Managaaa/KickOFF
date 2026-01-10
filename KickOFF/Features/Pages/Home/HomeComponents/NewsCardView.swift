import SwiftUI

struct NewsCardView: View {
    let title: String
    let subtitle: String
    let image: String
    let date: String
    var body: some View {
        ZStack {
            Color.customGray
                .frame(height: 190)
                .cornerRadius(12)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(FontType.medium.swiftUIFont(size: 12))
                        .foregroundStyle(.customGreen)
                    
                    Text(subtitle)
                        .font(FontType.medium.swiftUIFont(size: 13))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                AsyncImage(url: URL(string: image)) { phase in
                    if let loadedImage = phase.image {
                        loadedImage
                            .resizable()
                            .frame(width: 125, height: 100)
                            .scaledToFill()
                            .cornerRadius(10)
                            .clipped()
                            .padding(.bottom, 50)
                    } else {
                        Rectangle()
                            .frame(width: 130, height: 100)
                            .padding(.bottom, 50)
                            .foregroundStyle(.clear)
                    }
                }
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
                    
                } label: {
                    Image("favorite")
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
