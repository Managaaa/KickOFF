import Foundation
import Combine
import FirebaseAuth

final class ArticleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var body: String = ""

    @Published var alertTitle: String = "შეცდომა"
    @Published var alertMessage: String? = nil
    @Published var isAlertPresented: Bool = false
    @Published var isUploading: Bool = false
    @Published var shouldPopAfterAlert: Bool = false

    var onSuccess: (() -> Void)?

    private let authService: FirebaseAuthService
    private let articleService: ArticleService

    init(
        authService: FirebaseAuthService = .shared,
        articleService: ArticleService = .shared
    ) {
        self.authService = authService
        self.articleService = articleService
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
}

