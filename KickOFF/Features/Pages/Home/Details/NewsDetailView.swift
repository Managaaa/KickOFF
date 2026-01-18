import SwiftUI

struct NewsDetailView: View {
    let news: News
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel(), news: News) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.news = news
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ახალი ამბები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        GeometryReader { geometry in
                            KingfisherImageLoader.news(
                                imageUrl: news.imageUrl,
                                width: geometry.size.width,
                                height: 240,
                                cornerRadius: 10,
                                placeholder: Image(systemName: "photo")
                            )
                        }
                        .frame(height: 240)
                        .clipped()
                        
                        Text(viewModel.timeAgo(from: news.date))
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white)
                        
                        Text(news.title)
                            .font(FontType.medium.swiftUIFont(size: 16))
                            .foregroundStyle(.customGreen)
                        
                        VStack(alignment: .leading, spacing: 30) {
                            Text(news.subtitle)
                                .font(FontType.bold.swiftUIFont(size: 16))
                                .foregroundStyle(.white)
                            
                            Text(news.text)
                                .font(FontType.regular.swiftUIFont(size: 14))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }
}
