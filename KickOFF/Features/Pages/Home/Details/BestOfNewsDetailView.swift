import SwiftUI

struct BestOfNewsDetailView: View {
    let news: BestOfNews
    var onBestOfNewsTap: ((BestOfNews) -> Void)?
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel(), news: BestOfNews, onBestOfNewsTap: ((BestOfNews) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.news = news
        self.onBestOfNewsTap = onBestOfNewsTap
    }
    
    var recomendationNews: [BestOfNews] {
        viewModel.bestOfNews.filter { newsItem in
            newsItem.id != news.id
        }
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("BEST OF 2025")
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
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("რეკომენდაციები")
                                    .font(FontType.black.swiftUIFont(size: 20))
                                    .foregroundStyle(.white)
                                
                                ForEach(recomendationNews) { bestOfNews in
                                    BestOfsCardView(title: bestOfNews.title, subtitle: bestOfNews.subtitle, image: bestOfNews.imageUrl)
                                        .onTapGesture {
                                            onBestOfNewsTap?(bestOfNews)
                                        }
                                }
                            }
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
