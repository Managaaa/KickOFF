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
    
    private static let allCategory = Interest(id: "all", title: "ყველა", imageUrl: "")
    
    init(newsService: NewsService = NewsService(), interestService: InterestService = InterestService(), authService: FirebaseAuthService = .shared) {
        self.newsService = newsService
        self.interestService = interestService
        self.authService = authService
        self.selectedCategory = Self.allCategory
        fetchUserInterests()
        fetchNews()
    }
    
    func fetchUserInterests() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                guard let user = try await self.authService.getCurrentUser() else {
                    await MainActor.run {
                        self.categories = [Self.allCategory]
                        self.selectedCategory = Self.allCategory
                    }
                    return
                }
                
                let interestIds = user.interestIds ?? []
                
                await MainActor.run {
                    if interestIds.isEmpty {
                        self.categories = [Self.allCategory]
                        self.selectedCategory = Self.allCategory
                    }
                }
                
                guard !interestIds.isEmpty else {
                    return
                }
                
                let allInterests = await self.interestService.fetchInterests()
                let userInterests = allInterests.filter { interestIds.contains($0.id) }
                
                await MainActor.run {
                    let previousCategoryId = self.selectedCategory?.id
                    self.categories = [Self.allCategory] + userInterests
                    if let currentSelectedId = self.selectedCategory?.id,
                       !self.categories.contains(where: { $0.id == currentSelectedId }) {
                        self.selectedCategory = Self.allCategory
                        if self.selectedCategory?.id != previousCategoryId {
                            self.fetchNews()
                        }
                    } else if self.selectedCategory == nil {
                        self.selectedCategory = Self.allCategory
                        self.fetchNews()
                    }
                }
            } catch {
                await MainActor.run {
                    self.categories = [Self.allCategory]
                    self.selectedCategory = Self.allCategory
                }
            }
        }
    }
    
    func fetchNews() {
        isLoading = true
        
        Task { [weak self] in
            let allNews = await self?.newsService.fetchNews() ?? []
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                if let selectedCategory = self.selectedCategory {
                    if selectedCategory.id == Self.allCategory.id {
                        self.news = allNews
                    } else {
                        self.news = allNews.filter { news in
                            news.category.contains(selectedCategory.title)
                        }
                    }
                } else {
                    self.news = allNews
                }
                
                self.isLoading = false
            }
        }
    }
    
    func selectCategory(_ category: Interest) {
        selectedCategory = category
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
