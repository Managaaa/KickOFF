import SwiftUI

struct NewsDetailView: View {
    let news: News
    var onNewsTap: ((News, HomeViewModel?) -> Void)?
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel(), news: News, onNewsTap: ((News, HomeViewModel?) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.news = news
        self.onNewsTap = onNewsTap
    }
    
    var filteredNews: [News] {
        viewModel.news.filter { newsItem in
            newsItem.id != news.id &&
            !Set(news.category).isDisjoint(with: Set(newsItem.category))
        }
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
                        
                        HStack {
                            Text(viewModel.timeAgo(from: news.date))
                                .font(FontType.light.swiftUIFont(size: 12))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button {
                                viewModel.toggleFavoriteNews(news)
                            } label: {
                                HStack(spacing: 5) {
                                    Image(viewModel.isFavorite(news) ? "selectedfavorite" : "favorite")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text(viewModel.isFavorite(news) ? "ფავორიტებიდან წაშლა" : "ფავორიტებში დამატება")
                                        .font(FontType.light.swiftUIFont(size: 10))
                                        .foregroundStyle(viewModel.isFavorite(news) ? .customGreen : .white)
                                }
                            }
                        }
                        
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
                                
                                ForEach(filteredNews) { news in
                                    NewsCardView(
                                        title: news.title,
                                        subtitle: news.subtitle,
                                        image: news.imageUrl,
                                        date: viewModel.timeAgo(from: news.date),
                                        isFavorite: viewModel.isFavorite(news),
                                        onFavoriteTap: {
                                            viewModel.toggleFavoriteNews(news)
                                        }
                                    )
                                    .onTapGesture {
                                        onNewsTap?(news, viewModel)
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
