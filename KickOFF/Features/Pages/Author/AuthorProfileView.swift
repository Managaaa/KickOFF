import SwiftUI

struct AuthorProfileView: View {
    let author: Author
    var onArticleCardTap: ((Article) -> Void)?
    @StateObject private var viewModel: ArticleViewModel
    @ObservedObject private var authorViewModel = AuthorViewModel.shared

    init(author: Author, viewModel: ArticleViewModel, onArticleCardTap: ((Article) -> Void)? = nil) {
        self.author = author
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onArticleCardTap = onArticleCardTap
    }

    private var displayAuthor: Author {
        authorViewModel.authors.first { $0.userId == author.userId } ?? author
    }

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if let imageUrl = displayAuthor.profileImageUrl {
                        KingfisherImageLoader.profilePicture(
                            imageUrl: imageUrl,
                            size: 100,
                            placeholder: Image("pfp")
                        )
                    } else {
                        Image("pfp")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    Text(displayAuthor.name)
                        .font(FontType.bold.swiftUIFont(size: 20))
                        .foregroundStyle(.white)

                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(.heart)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)

                            Text("\(displayAuthor.totalLikes) მოწონება")
                                .font(FontType.light.swiftUIFont(size: 12))
                                .foregroundStyle(.white)
                        }

                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(width: 1, height: 16)

                        HStack(spacing: 6) {
                            Image(.subscribers)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)

                            Text("\(displayAuthor.subscribers) გამომწერი")
                                .font(FontType.light.swiftUIFont(size: 12))
                                .foregroundStyle(.white)
                        }
                    }

                    Button {
                        Task {
                            await authorViewModel.toggleSubscription(displayAuthor)
                        }
                    } label: {
                        Image(authorViewModel.isSubscribed(to: displayAuthor.userId) ? .unsubscribebutton : .subscribebutton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 35)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(height: 1)

                        Text("არტიკლები")
                            .font(FontType.black.swiftUIFont(size: 20))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 200)
                        } else {
                            VStack(alignment: .leading, spacing: 20) {
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
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            authorViewModel.isAuthorInList(author)
            viewModel.fetchArticlesForAuthor(userId: author.userId)
        }
    }
}
