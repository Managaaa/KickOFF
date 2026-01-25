import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResultsNews: [News] = []
    @Published var searchResultsBestOfNews: [BestOfNews] = []
    @Published var searchResultsQuizzes: [Quiz] = []
    @Published var searchResultsArticles: [Article] = []
    @Published var searchResultsAuthors: [Author] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let articleService = ArticleService.shared
    private let newsService = NewsService()
    private let quizService = QuizService()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResultsNews = []
            searchResultsBestOfNews = []
            searchResultsQuizzes = []
            searchResultsArticles = []
            searchResultsAuthors = []
            return
        }

        let q = trimmed.lowercased()
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            async let newsTask = newsService.fetchNews()
            async let bestOfTask = newsService.fetchBestOfNews()
            async let quizzesTask = quizService.fetchQuizzes()
            let (allNews, allBestOf, allQuizzes) = await (newsTask, bestOfTask, quizzesTask)
            let articles = (try? await articleService.searchArticles(query: trimmed)) ?? []

            let news = allNews.filter {
                $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q)
            }
            let bestOf = allBestOf.filter {
                $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q)
            }
            let quizzes = allQuizzes.filter { $0.title.lowercased().contains(q) }
            let authors = AuthorViewModel.shared.authors.filter {
                $0.name.lowercased().contains(q)
            }

            await MainActor.run {
                self.searchResultsNews = news
                self.searchResultsBestOfNews = bestOf
                self.searchResultsQuizzes = quizzes
                self.searchResultsArticles = articles
                self.searchResultsAuthors = authors
                self.isLoading = false
            }
        }
    }

    var hasAnyResults: Bool {
        !searchResultsNews.isEmpty || !searchResultsBestOfNews.isEmpty ||
        !searchResultsQuizzes.isEmpty || !searchResultsArticles.isEmpty ||
        !searchResultsAuthors.isEmpty
    }

    func timeAgo(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        let minute = 60
        let hour = 3600
        let day = 86400
        if seconds < minute { return "ახლახანს" }
        if seconds < hour { return "\(seconds / minute) წუთის წინ" }
        if seconds < day { return "\(seconds / hour) საათის წინ" }
        return "\(seconds / day) დღის წინ"
    }
}
