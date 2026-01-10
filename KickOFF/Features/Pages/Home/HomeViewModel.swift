import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var bestOfNews: [BestOfNews] = []
    @Published var news: [News] = []
    @Published var isLoading: Bool = false
    
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
        fetchBestOfNews()
        fetchNews()
    }
    
    func fetchBestOfNews() {
        isLoading = true
        
        newsService.fetchBestOfNews { [weak self] news in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.bestOfNews = news
                
            }
        }
    }
    func fetchNews() {
        isLoading = true
        
        newsService.fetchNews { [weak self] news in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.news = news
            }
        }
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
}
