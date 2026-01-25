import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @StateObject private var viewModel = ArticleViewModel()
    var onDelete: (() -> Void)?
    @State private var commentText: String = ""

    init(article: Article, onDelete: (() -> Void)? = nil) {
        self.article = article
        self.onDelete = onDelete
    }

    private var displayArticle: Article {
        viewModel.detailArticle ?? article
    }

    private var displayArticleIsLiked: Bool {
        viewModel.isArticleLiked(displayArticle)
    }

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(article.title)
                        .font(FontType.black.swiftUIFont(size: 20))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 5) {
                        Text(viewModel.timeAgo(from: displayArticle.timestamp))
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text("~")
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Image(displayArticleIsLiked ? .tappedHeart : .heart)
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("\(displayArticle.likes) მოწონება")
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    HStack(spacing: 10) {
                        KingfisherImageLoader.profilePicture(
                            imageUrl: article.profileImageUrl.isEmpty ? nil : article.profileImageUrl,
                            size: 30,
                            placeholder: Image("pfp")
                        )
                        
                        HStack {
                            Text(article.senderName)
                                .font(FontType.medium.swiftUIFont(size: 12))
                                .foregroundStyle(.customGreen)
                            
                            Spacer()
                            
                            if viewModel.isArticleOwner(article) {
                                Button {
                                    viewModel.showDeleteConfirmation = true
                                } label: {
                                    Image("delete")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            
                            Button {
                                Task {
                                    await viewModel.toggleLike(displayArticle)
                                }
                            } label: {
                                Image(displayArticleIsLiked ? .tappedHeart : .heart)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    
                    Text(article.text)
                        .font(FontType.medium.swiftUIFont(size: 14))
                        .foregroundStyle(.white)
                        .padding(.top, 10)

                    Text("კომენტარები")
                        .font(FontType.black.swiftUIFont(size: 16))
                        .foregroundStyle(.white)
                        .padding(.top, 24)

                    if viewModel.isLoadingComments {
                        ProgressView()
                            .padding()
                    } else if viewModel.comments.isEmpty {
                        Text("კომენტარები არ არის")
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(.top, 2)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.comments) { comment in
                                CommentCard(
                                    comment: comment,
                                    timeAgo: viewModel.timeAgo(from: comment.timestamp),
                                    canDelete: viewModel.isCommentAuthor(comment),
                                    isDeleteDisabled: viewModel.isDeletingComment,
                                    onDelete: {
                                        viewModel.commentToDelete = (article.id, comment.id)
                                        viewModel.showDeleteCommentConfirmation = true
                                    }
                                )
                            }
                        }
                    }

                    CommentTextField(
                        text: $commentText,
                        isDisabled: viewModel.isSendingComment,
                        onSend: {
                            Task {
                                let success = await viewModel.addComment(articleId: article.id, text: commentText)
                                if success { commentText = "" }
                            }
                        }
                    )
                    .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            viewModel.onDelete = { onDelete?() }
            viewModel.detailArticle = article
            viewModel.fetchComments(articleId: article.id)
        }
        .alert("ნამდვილად გინდა არტიკლის წაშლა?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("კი", role: .destructive) {
                Task {
                    await viewModel.deleteArticle(article)
                }
            }
            Button("არა", role: .cancel) { }
        }
        .alert("ნამდვილად გინდა კომენტარის წაშლა?", isPresented: $viewModel.showDeleteCommentConfirmation) {
            Button("კი", role: .destructive) {
                guard let pair = viewModel.commentToDelete else { return }
                Task {
                    await viewModel.deleteComment(articleId: pair.articleId, commentId: pair.commentId)
                }
            }
            Button("არა", role: .cancel) {
                viewModel.commentToDelete = nil
                viewModel.showDeleteCommentConfirmation = false
            }
        }
        .alert(Text(viewModel.alertTitle), isPresented: $viewModel.isAlertPresented) {
            Button("კარგი", role: .cancel) {
                viewModel.handleAlertOKTap()
            }
        } message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }
    }
}

