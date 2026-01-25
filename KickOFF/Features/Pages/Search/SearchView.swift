import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var onNewsTap: ((News) -> Void)?
    var onBestOfNewsTap: ((BestOfNews) -> Void)?
    var onQuizTap: ((Quiz) -> Void)?
    var onArticleTap: ((Article) -> Void)?
    var onAuthorTap: ((Author) -> Void)?
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("ძებნა")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
                
                TextField("", text: $viewModel.searchQuery, prompt: Text("ძებნა...")
                    .font(FontType.medium.swiftUIFont(size: 12))
                    .foregroundStyle(.gray))
                .textFieldStyle(.plain)
                .font(FontType.medium.swiftUIFont(size: 14))
                .foregroundStyle(.white)
                .tint(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGray, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text("შეიყვანე საძიებო ტექსტი")
                                .font(FontType.light.swiftUIFont(size: 14))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.top, 24)
                                .frame(maxWidth: .infinity)
                        } else if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        } else if !viewModel.hasAnyResults {
                            Text("შედეგი ვერ მოიძებნა")
                                .font(FontType.light.swiftUIFont(size: 14))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.top, 24)
                                .frame(maxWidth: .infinity)
                        } else {
                            if !viewModel.searchResultsNews.isEmpty {
                                sectionHeader("ახალი ამბები")
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.searchResultsNews) { news in
                                        SearchNewsRow(news: news, timeAgo: viewModel.timeAgo(from: news.date))
                                            .onTapGesture {
                                                onNewsTap?(news)
                                            }
                                    }
                                }
                            }
                            if !viewModel.searchResultsBestOfNews.isEmpty {
                                sectionHeader("Best Of 2025")
                                    .padding(.top, 8)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.searchResultsBestOfNews) { news in
                                        SearchBestOfNewsRow(news: news)
                                            .onTapGesture {
                                                onBestOfNewsTap?(news)
                                            }
                                    }
                                }
                            }
                            if !viewModel.searchResultsQuizzes.isEmpty {
                                sectionHeader("ქვიზები")
                                    .padding(.top, 8)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.searchResultsQuizzes) { quiz in
                                        SearchQuizRow(quiz: quiz)
                                            .onTapGesture {
                                                onQuizTap?(quiz)
                                            }
                                    }
                                }
                            }
                            if !viewModel.searchResultsArticles.isEmpty {
                                sectionHeader("არტიკლები")
                                    .padding(.top, 8)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.searchResultsArticles) { article in
                                        SearchArticleRow(article: article, timeAgo: viewModel.timeAgo(from: article.timestamp))
                                            .onTapGesture {
                                                onArticleTap?(article)
                                            }
                                    }
                                }
                            }
                            if !viewModel.searchResultsAuthors.isEmpty {
                                sectionHeader("ავტორები")
                                    .padding(.top, 8)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(viewModel.searchResultsAuthors) { author in
                                        SearchAuthorRow(author: author)
                                            .onTapGesture {
                                                onAuthorTap?(author)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(FontType.black.swiftUIFont(size: 16))
            .foregroundStyle(.white)
    }
}
