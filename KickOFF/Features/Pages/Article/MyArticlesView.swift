import SwiftUI

struct MyArticlesView: View {
    var onArticleCardTap: ((Article) -> Void)?
    @StateObject private var viewModel = ArticleViewModel()

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ჩემი არტიკლები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else if viewModel.articles.isEmpty {
                            Text("თქვენ არ გაქვთ არტიკლები")
                                .font(FontType.medium.swiftUIFont(size: 14))
                                .foregroundStyle(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else {
                            ForEach(viewModel.articles) { article in
                                ArticleCardView(
                                    authorName: article.senderName,
                                    authorProfileImageUrl: article.profileImageUrl.isEmpty ? nil : article.profileImageUrl,
                                    title: article.title,
                                    date: viewModel.timeAgo(from: article.timestamp),
                                    article: article,
                                    likes: article.likes,
                                    isLiked: viewModel.isArticleLiked(article),
                                    onLikeTap: {
                                        Task {
                                            await viewModel.toggleLike(article)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    onArticleCardTap?(article)
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
        .onAppear {
            viewModel.fetchUserArticles()
        }
    }
}
