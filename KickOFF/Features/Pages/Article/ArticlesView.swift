import SwiftUI

struct ArticlesView: View {
    var onWriteTap: (() -> Void)?
    @StateObject private var viewModel = ArticleViewModel()

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("არტიკლები")
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
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)

            Button {
                onWriteTap?()
            } label: {
                Image(.write)
                    .resizable()
                    .frame(width: 54, height: 54)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 30)
            .padding(.bottom, 20)
        }
        .onAppear {
            viewModel.fetchArticles()
        }
    }
}
