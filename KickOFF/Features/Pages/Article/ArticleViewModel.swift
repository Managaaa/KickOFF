import Foundation
import Combine
import FirebaseAuth

final class ArticleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var body: String = ""

    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false

    @Published var alertTitle: String = "შეცდომა"
    @Published var alertMessage: String? = nil
    @Published var isAlertPresented: Bool = false
    @Published var isUploading: Bool = false
    @Published var shouldPopAfterAlert: Bool = false
    @Published var currentUserId: String?
    @Published var showDeleteConfirmation: Bool = false
    @Published var comments: [Comment] = []
    @Published var isLoadingComments: Bool = false
    @Published var isSendingComment: Bool = false
    @Published var isDeletingComment: Bool = false
    @Published var commentToDelete: (articleId: String, commentId: String)?
    @Published var showDeleteCommentConfirmation: Bool = false
    @Published var detailArticle: Article?

    var onSuccess: (() -> Void)?
    var onDelete: (() -> Void)?

    private let authService: FirebaseAuthService
    private let articleService: ArticleService

    init(
        authService: FirebaseAuthService = .shared,
        articleService: ArticleService = .shared
    ) {
        self.authService = authService
        self.articleService = articleService
        Task {
            await loadCurrentUserId()
        }
    }
    
    @MainActor
    private func loadCurrentUserId() async {
        do {
            if let user = try await authService.getCurrentUser() {
                currentUserId = user.id ?? Auth.auth().currentUser?.uid
            }
        } catch {
            currentUserId = Auth.auth().currentUser?.uid
        }
    }
    
    func isArticleLiked(_ article: Article) -> Bool {
        guard let userId = currentUserId else { return false }
        return article.likedBy.contains(userId)
    }
    
    func fetchArticles() {
        isLoading = true

        Task { [weak self] in
            guard let self else { return }
            do {
                if self.currentUserId == nil {
                    await self.loadCurrentUserId()
                }
                
                let fetched = try await articleService.fetchArticles()
                await MainActor.run {
                    self.articles = fetched
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchUserArticles() {
        isLoading = true

        Task { [weak self] in
            guard let self else { return }
            do {
                if self.currentUserId == nil {
                    await self.loadCurrentUserId()
                }
                
                let userId = self.currentUserId ?? Auth.auth().currentUser?.uid
                
                guard let userId = userId else {
                    await MainActor.run {
                        self.isLoading = false
                        self.articles = []
                    }
                    return
                }
                
                let fetched = try await articleService.fetchUserArticles(userId: userId)
                await MainActor.run {
                    self.articles = fetched
                    self.isLoading = false
                }
            } catch {
                print(error)
                await MainActor.run {
                    self.isLoading = false
                    self.articles = []
                }
            }
        }
    }

    func fetchArticlesForAuthor(userId: String) {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                if self.currentUserId == nil {
                    await self.loadCurrentUserId()
                }
                let fetched = try await articleService.fetchUserArticles(userId: userId)
                await MainActor.run {
                    self.articles = fetched
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.articles = []
                }
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

    @MainActor
    func share() async {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedTitle.isEmpty {
            presentErrorAlert(message: "სათაურის ველი ცარიელია")
            return
        }

        if trimmedBody.isEmpty {
            presentErrorAlert(message: "არტიკლის ველი ცარიელია")
            return
        }

        isUploading = true
        defer { isUploading = false }

        do {
            guard let currentUser = try await authService.getCurrentUser() else {
                presentErrorAlert(message: "ცადეთ თავიდან")
                return
            }

            let senderId = currentUser.id ?? Auth.auth().currentUser?.uid ?? ""
            if senderId.isEmpty {
                presentErrorAlert(message: "ცადეთ თავიდან")
                return
            }

            _ = try await articleService.createArticle(
                title: trimmedTitle,
                text: trimmedBody,
                senderId: senderId,
                senderName: currentUser.name,
                profileImageUrl: currentUser.profileImageUrl ?? ""
            )

            title = ""
            body = ""
            presentSuccessAndPreparePop(message: "")
        } catch {
            presentErrorAlert(message: "ცადეთ თავიდან")
        }
    }

    func handleAlertOKTap() {
        let shouldPop = shouldPopAfterAlert
        alertMessage = nil
        isAlertPresented = false
        shouldPopAfterAlert = false

        if shouldPop {
            onSuccess?()
        }
    }

    private func presentErrorAlert(message: String) {
        alertTitle = "შეცდომა"
        shouldPopAfterAlert = false
        alertMessage = message
        isAlertPresented = true
    }

    private func presentSuccessAndPreparePop(message: String) {
        alertTitle = "მადლობა შენი აზრების გაზიარებისთვის"
        shouldPopAfterAlert = true
        alertMessage = message
        isAlertPresented = true
    }
    
    @MainActor
    func toggleLike(_ article: Article) async {
        do {
            guard let currentUser = try await authService.getCurrentUser() else {
                return
            }

            if currentUserId == nil {
                await loadCurrentUserId()
            }

            let userId = currentUser.id ?? Auth.auth().currentUser?.uid ?? ""
            if userId.isEmpty {
                return
            }

            let isCurrentlyLiked = article.likedBy.contains(userId)
            var updatedLikedBy = article.likedBy
            let updatedArticle: Article

            if isCurrentlyLiked {
                updatedLikedBy.removeAll { $0 == userId }
                updatedArticle = Article(
                    id: article.id,
                    title: article.title,
                    text: article.text,
                    senderId: article.senderId,
                    senderName: article.senderName,
                    profileImageUrl: article.profileImageUrl,
                    timestamp: article.timestamp,
                    likes: max(0, article.likes - 1),
                    likedBy: updatedLikedBy
                )
                try await articleService.unlikeArticle(articleId: article.id, userId: userId)
            } else {
                updatedLikedBy.append(userId)
                updatedArticle = Article(
                    id: article.id,
                    title: article.title,
                    text: article.text,
                    senderId: article.senderId,
                    senderName: article.senderName,
                    profileImageUrl: article.profileImageUrl,
                    timestamp: article.timestamp,
                    likes: article.likes + 1,
                    likedBy: updatedLikedBy
                )
                try await articleService.likeArticle(articleId: article.id, userId: userId)
            }

            if let index = articles.firstIndex(where: { $0.id == article.id }) {
                var updated = articles
                updated[index] = updatedArticle
                articles = updated
            }

            if detailArticle?.id == article.id {
                detailArticle = updatedArticle
            }

            let amount = isCurrentlyLiked ? -1 : 1
            AuthorViewModel.shared.updateAuthorTotalLikes(userId: article.senderId, amount: amount)
        } catch {
            fetchArticles()
            print(error)
        }
    }
    
    @MainActor
    func deleteArticle(_ article: Article) async {
        do {
            try await articleService.deleteArticle(articleId: article.id)
            onDelete?()
        } catch {
            presentErrorAlert(message: "ცადეთ თავიდან")
        }
    }
    
    func isArticleOwner(_ article: Article) -> Bool {
        guard let userId = currentUserId else { return false }
        return article.senderId == userId
    }

    func isCommentAuthor(_ comment: Comment) -> Bool {
        guard let userId = currentUserId else { return false }
        return comment.senderId == userId
    }

    func fetchComments(articleId: String) {
        isLoadingComments = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let fetched = try await articleService.fetchComments(articleId: articleId)
                await MainActor.run {
                    self.comments = fetched
                    self.isLoadingComments = false
                }
            } catch {
                await MainActor.run {
                    self.comments = []
                    self.isLoadingComments = false
                }
            }
        }
    }

    @MainActor
    func addComment(articleId: String, text: String) async -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard let user = try? await authService.getCurrentUser() else { return false }
        let senderId = user.id ?? Auth.auth().currentUser?.uid ?? ""
        guard !senderId.isEmpty else { return false }

        isSendingComment = true
        defer { isSendingComment = false }
        do {
            let commentId = try await articleService.addComment(
                articleId: articleId,
                senderId: senderId,
                senderName: user.name,
                profileImageUrl: user.profileImageUrl,
                text: trimmed
            )
            let newComment = Comment(
                id: commentId,
                articleId: articleId,
                senderId: senderId,
                senderName: user.name,
                profileImageUrl: user.profileImageUrl,
                text: trimmed,
                timestamp: Date()
            )
            comments.append(newComment)
            return true
        } catch {
            presentErrorAlert(message: "კომენტარის გაგზავნა ვერ მოხერხდა")
            return false
        }
    }

    @MainActor
    func deleteComment(articleId: String, commentId: String) async {
        isDeletingComment = true
        defer { isDeletingComment = false }
        do {
            try await articleService.deleteComment(articleId: articleId, commentId: commentId)
            comments.removeAll { $0.id == commentId }
            commentToDelete = nil
            showDeleteCommentConfirmation = false
        } catch {
            presentErrorAlert(message: "კომენტარის წაშლა ვერ მოხერხდა")
        }
    }
}

