import SwiftUI

struct NewsCardView: View {
    var body: some View {
        ZStack {
            Color.customGray
                .frame(height: 190)
                .cornerRadius(12)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("ქუთაისის თასი 2025")
                        .font(FontType.medium.swiftUIFont(size: 12))
                        .foregroundStyle(.customGreen)
                    
                    Text("მანაგაძემ გაიტანა 2 გოლი 3 ასისტი - ტორპედო ნახევარ ფინალშია")
                        .font(FontType.medium.swiftUIFont(size: 13))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 125, height: 100)
                    .padding(.bottom, 50)
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
                Text("2 საათის წინ")
                    .font(FontType.light.swiftUIFont(size: 10))
                    .foregroundStyle(.white)
                
                Spacer()
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Image("heart")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                    HStack(spacing: 22) {
                        Button {
                            
                        } label: {
                            Image("comment")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Button {
                            
                        } label: {
                            Image("favorite")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}


#Preview {
    NewsCardView()
}
