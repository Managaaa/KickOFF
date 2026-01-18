import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var isLoading: Bool = false
    @Published var categories: [Interest] = []
    @Published var selectedCategory: Interest?
    
    private let newsService: NewsService
    private let interestService: InterestService
    private let authService: FirebaseAuthService
    
    init(newsService: NewsService = NewsService(), interestService: InterestService = InterestService(), authService: FirebaseAuthService = .shared) {
        self.newsService = newsService
        self.interestService = interestService
        self.authService = authService
        fetchUserInterests()
        fetchNews()
    }
    
    func fetchUserInterests() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                guard let user = try await self.authService.getCurrentUser() else {
                    await MainActor.run {
                        self.categories = []
                        self.selectedCategory = nil
                    }
                    return
                }
                
                let interestIds = user.interestIds ?? []
                
                guard !interestIds.isEmpty else {
                    await MainActor.run {
                        self.categories = []
                        self.selectedCategory = nil
                    }
                    return
                }
                
                let allInterests = await self.interestService.fetchInterests()
                let userInterests = allInterests.filter { interestIds.contains($0.id) }
                
                await MainActor.run {
                    self.categories = userInterests
                    if let currentSelectedId = self.selectedCategory?.id,
                       !userInterests.contains(where: { $0.id == currentSelectedId }) {
                        self.selectedCategory = userInterests.first
                    } else if self.selectedCategory == nil, let firstCategory = userInterests.first {
                        self.selectedCategory = firstCategory
                    }
                }
            } catch {
                await MainActor.run {
                    self.categories = []
                    self.selectedCategory = nil
                }
            }
        }
    }
    
    func fetchNews() {
        isLoading = true
        
        Task { [weak self] in
            let news = await self?.newsService.fetchNews() ?? []
            
            await MainActor.run(body:  {
                self?.news = news
                self?.isLoading = false
            })
        }
    }
    
    func selectCategory(_ category: Interest) {
        selectedCategory = category
        // TODO: filter news based on selected category
        fetchNews()
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
