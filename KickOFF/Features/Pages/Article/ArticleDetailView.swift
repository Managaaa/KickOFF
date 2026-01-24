import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @StateObject private var viewModel = ArticleViewModel()
    var onDelete: (() -> Void)?
    
    init(article: Article, onDelete: (() -> Void)? = nil) {
        self.article = article
        self.onDelete = onDelete
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
                        Text(viewModel.timeAgo(from: article.timestamp))
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text("~")
                            .font(FontType.light.swiftUIFont(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Image(.heart)
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("\(article.likes) მოწონება")
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
                        }
                    }
                    
                    Text(article.text)
                        .font(FontType.medium.swiftUIFont(size: 14))
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
        }
        .onAppear {
            viewModel.onDelete = {
                onDelete?()
            }
        }
        .alert("ნამდვილად გინდა არტიკლის წაშლა?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("კი", role: .destructive) {
                Task {
                    await viewModel.deleteArticle(article)
                }
            }
            Button("არა", role: .cancel) { }
        }
    }
}

