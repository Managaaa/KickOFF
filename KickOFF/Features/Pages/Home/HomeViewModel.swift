import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var bestOfNews: [BestOfNews] = []
    @Published var isLoading: Bool = false
    
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
        fetchBestOfNews()
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
}
