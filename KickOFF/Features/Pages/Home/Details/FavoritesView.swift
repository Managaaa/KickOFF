import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: HomeViewModel
    var onNewsTap: ((News, HomeViewModel?) -> Void)?

    init(viewModel: HomeViewModel, onNewsTap: ((News, HomeViewModel?) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNewsTap = onNewsTap
    }
    
    var favoriteNews: [News] {
        viewModel.news.filter { viewModel.isFavorite($0) }
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ფავორიტები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else if favoriteNews.isEmpty {
                            Text("არ გაქვს ფავორიტი სიახლეები...")
                                .font(FontType.medium.swiftUIFont(size: 14))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.top, 100)
                        } else {
                            ForEach(favoriteNews) { news in
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
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .top)
    }
}

