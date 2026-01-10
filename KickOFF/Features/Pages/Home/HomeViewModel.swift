import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var bestOfNews: [BestOfNews] = []
    @Published var isLoading: Bool = false
    
    private let bestOfNewsService: BestOfNewsService
    
    init(bestOfNewsService: BestOfNewsService = BestOfNewsService()) {
        self.bestOfNewsService = bestOfNewsService
        fetchBestOfNews()
    }
    
    func fetchBestOfNews() {
        isLoading = true
        
        bestOfNewsService.fetchNews { [weak self] news in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.bestOfNews = news
                
            }
        }
    }
}
