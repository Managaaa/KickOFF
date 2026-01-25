import Combine
import Foundation

extension Notification.Name {
    static let favoriteNewsChanged = Notification.Name("favoriteNewsChanged")
}

class HomeViewModel: ObservableObject {
    @Published var bestOfNews: [BestOfNews] = []
    @Published var news: [News] = []
    @Published var quizzes: [Quiz] = []
    @Published var isLoading: Bool = false
    @Published var favoriteNewsIds: Set<String> = []
    
    private let newsService: NewsServiceProtocol
    private let quizService: QuizServiceProtocol
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(newsService: NewsServiceProtocol = NewsService(), quizService: QuizServiceProtocol = QuizService(), authService: AuthServiceProtocol = FirebaseAuthService.shared) {
        self.newsService = newsService
        self.quizService = quizService
        self.authService = authService
        fetchBestOfNews()
        fetchNews()
        fetchQuizzes()
        loadFavoriteNews()
        setupFavoriteNewsObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupFavoriteNewsObserver() {
        NotificationCenter.default.publisher(for: .favoriteNewsChanged)
            .compactMap { notification -> (newsId: String, isFavorite: Bool)? in
                guard let userInfo = notification.userInfo,
                      let newsId = userInfo["newsId"] as? String,
                      let isFavorite = userInfo["isFavorite"] as? Bool else {
                    return nil
                }
                return (newsId, isFavorite)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newsId, isFavorite in
                if isFavorite {
                    self?.favoriteNewsIds.insert(newsId)
                } else {
                    self?.favoriteNewsIds.remove(newsId)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchBestOfNews() {
        isLoading = true
        
        Task { [weak self] in
            let news = await self?.newsService.fetchBestOfNews() ?? []
            
            await MainActor.run {
                self?.bestOfNews = news
                self?.isLoading = false
            }
        }
    }
    
    func fetchNews() {
        isLoading = true
        
        Task { [weak self] in
            let news = await self?.newsService.fetchNews(limit: nil) ?? []
            
            await MainActor.run(body:  {
                self?.news = news
                self?.isLoading = false
            })
        }
    }
    
    func fetchQuizzes() {
        isLoading = true
        
        Task { [weak self] in
            let quizzes = await self?.quizService.fetchQuizzes() ?? []
            
            await MainActor.run {
                self?.quizzes = quizzes
                self?.isLoading = false
            }
        }
    }
    
    var displayedNews: [News] {
        Array(news.prefix(4))
    }
    
    func timeAgo(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        
        let minute = 60
        let hour = 3600
        let day = 86400
        
        if seconds < minute {
            return "ახლახანს"
        } else if seconds < hour {
            return "\(seconds / minute) წუთის წინ"
        } else if seconds < day {
            return "\(seconds / hour) საათის წინ"
        } else {
            return "\(seconds / day) დღის წინ"
        }
    }
    
    func loadFavoriteNews() {
        Task {
            do {
                if let user = try await authService.getCurrentUser() {
                    _ = await MainActor.run {
                        favoriteNewsIds = Set(user.favoriteNews ?? [])
                    }
                }
            } catch {

            }
        }
    }
    
    func toggleFavoriteNews(_ news: News) {
        Task {
            do {
                let isFavorite = favoriteNewsIds.contains(news.id)
                let newState = !isFavorite
                
                if isFavorite {
                    try await newsService.removeFavoriteNews(newsId: news.id)
                } else {
                    try await newsService.addFavoriteNews(newsId: news.id)
                }
                
                _ = await MainActor.run {
                    if newState {
                        favoriteNewsIds.insert(news.id)
                    } else {
                        favoriteNewsIds.remove(news.id)
                    }
                    
                    NotificationCenter.default.post(
                        name: .favoriteNewsChanged,
                        object: nil,
                        userInfo: ["newsId": news.id, "isFavorite": newState]
                    )
                }
            } catch {

            }
        }
    }
    
    func isFavorite(_ news: News) -> Bool {
        favoriteNewsIds.contains(news.id)
    }
}
