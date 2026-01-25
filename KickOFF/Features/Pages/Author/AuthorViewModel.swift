import Foundation
import Combine

final class AuthorViewModel: ObservableObject {
    static let shared = AuthorViewModel()
    
    @Published var authors: [Author] = []
    @Published var isLoading: Bool = false
    @Published var subscribedAuthorIds: Set<String> = []
    
    private let userService: UserServiceProtocol
    private let authService: AuthServiceProtocol

    init(
        userService: UserServiceProtocol = UserService.shared,
        authService: AuthServiceProtocol = FirebaseAuthService.shared
    ) {
        self.userService = userService
        self.authService = authService
        Task {
            await fetchAuthors()
            await loadSubscribedAuthors()
        }
    }
    
    @MainActor
    func fetchAuthors() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedAuthors = try await userService.fetchAuthorsWithArticles()
            authors = fetchedAuthors
        } catch {
            print(error)
            authors = []
        }
    }
    
    @MainActor
    func loadSubscribedAuthors() async {
        do {
            if let currentUser = try await authService.getCurrentUser() {
                subscribedAuthorIds = Set(currentUser.subscribedTo ?? [])
            }
        } catch {
            print(error)
        }
    }
    
    func isSubscribed(to authorId: String) -> Bool {
        subscribedAuthorIds.contains(authorId)
    }

    @MainActor
    func isAuthorInList(_ author: Author) {
        guard !authors.contains(where: { $0.userId == author.userId }) else { return }
        authors.append(author)
    }

    @MainActor
    func updateAuthorTotalLikes(userId: String, amount: Int) {
        guard let index = authors.firstIndex(where: { $0.userId == userId }) else { return }
        let current = authors[index]
        let newTotal = max(0, current.totalLikes + amount)
        let updated = Author(
            userId: current.userId,
            name: current.name,
            profileImageUrl: current.profileImageUrl,
            totalLikes: newTotal,
            subscribers: current.subscribers,
            articleCount: current.articleCount
        )
        var list = authors
        list[index] = updated
        authors = list
    }

    @MainActor
    func toggleSubscription(_ author: Author) async {
        let isCurrentlySubscribed = subscribedAuthorIds.contains(author.userId)
        
        if isCurrentlySubscribed {
            await unsubscribeFromAuthor(author)
        } else {
            await subscribeToAuthor(author)
        }
    }
    
    @MainActor
    private func subscribeToAuthor(_ author: Author) async {
        guard !subscribedAuthorIds.contains(author.userId) else {
            return
        }
        
        subscribedAuthorIds.insert(author.userId)
        if let index = authors.firstIndex(where: { $0.userId == author.userId }) {
            let currentAuthor = authors[index]
            let updatedAuthor = Author(
                userId: currentAuthor.userId,
                name: currentAuthor.name,
                profileImageUrl: currentAuthor.profileImageUrl,
                totalLikes: currentAuthor.totalLikes,
                subscribers: currentAuthor.subscribers + 1,
                articleCount: currentAuthor.articleCount
            )
            var updated = authors
            updated[index] = updatedAuthor
            authors = updated
        }
        
        do {
            try await userService.subscribeToUser(authorId: author.userId)
        } catch {
            subscribedAuthorIds.remove(author.userId)
            if let index = authors.firstIndex(where: { $0.userId == author.userId }) {
                let currentAuthor = authors[index]
                let updatedAuthor = Author(
                    userId: currentAuthor.userId,
                    name: currentAuthor.name,
                    profileImageUrl: currentAuthor.profileImageUrl,
                    totalLikes: currentAuthor.totalLikes,
                    subscribers: max(0, currentAuthor.subscribers - 1),
                    articleCount: currentAuthor.articleCount
                )
                var updated = authors
                updated[index] = updatedAuthor
                authors = updated
            }
            print(error)
        }
    }
    
    @MainActor
    private func unsubscribeFromAuthor(_ author: Author) async {
        guard subscribedAuthorIds.contains(author.userId) else {
            return
        }
        
        subscribedAuthorIds.remove(author.userId)
        if let index = authors.firstIndex(where: { $0.userId == author.userId }) {
            let currentAuthor = authors[index]
            let updatedAuthor = Author(
                userId: currentAuthor.userId,
                name: currentAuthor.name,
                profileImageUrl: currentAuthor.profileImageUrl,
                totalLikes: currentAuthor.totalLikes,
                subscribers: max(0, currentAuthor.subscribers - 1),
                articleCount: currentAuthor.articleCount
            )
            var updated = authors
            updated[index] = updatedAuthor
            authors = updated
        }
        
        do {
            try await userService.unsubscribeFromUser(authorId: author.userId)
        } catch {
            subscribedAuthorIds.insert(author.userId)
            if let index = authors.firstIndex(where: { $0.userId == author.userId }) {
                let currentAuthor = authors[index]
                let updatedAuthor = Author(
                    userId: currentAuthor.userId,
                    name: currentAuthor.name,
                    profileImageUrl: currentAuthor.profileImageUrl,
                    totalLikes: currentAuthor.totalLikes,
                    subscribers: currentAuthor.subscribers + 1,
                    articleCount: currentAuthor.articleCount
                )
                var updated = authors
                updated[index] = updatedAuthor
                authors = updated
            }
            print(error)
        }
    }
    
    var displayedAuthors: [Author] {
        authors
    }
    
    var subscribedAuthors: [Author] {
        authors.filter { subscribedAuthorIds.contains($0.userId) }
    }
}
