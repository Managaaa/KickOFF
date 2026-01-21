import UIKit
import SwiftUI

//MARK: - TabBar Tags
enum AppTab: Int {
    case home = 0
    case news = 1
    case search = 2
    case article = 3
    case profile = 4
}

final class MainTabCoordinator: Coordinator {
    //MARK: - Properties
    var selectedTab: AppTab?
    var navigationController: UINavigationController
    var onLogout: (() -> Void)?
    private weak var tabBarController: UITabBarController?
    
    //MARK: - Init
    init(navigationController: UINavigationController, selectedTab: AppTab? = nil) {
        self.navigationController = navigationController
        self.selectedTab = selectedTab
    }
    
    //MARK: - TabBarPages
    func start() {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        
        let homeViewModel = HomeViewModel()
        let homeView = HomeView(
            viewModel: homeViewModel,
            onBestOfNewsTap: { [weak self] news in
                self?.showBestOfNewsDetails(news)
            },
            onNewsTap: { [weak self] news in
                self?.showNewsDetails(news)
            },
            onQuizTap: { [weak self] quiz in
                self?.showQuizDetails(quiz)
            },
            onSeeAllTap: { [weak self] in
                self?.switchToNewsTab()
            }
        )
        let homeViewController = UIHostingController(rootView: homeView)
        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: AppTab.home.rawValue)
        
        let newsViewModel = NewsViewModel()
        let newsView = NewsView(
            viewModel: newsViewModel,
            onNewsTap: { [weak self]  news in
                self?.showNewsDetails(news)
            })
        let newsViewController = UIHostingController(rootView: newsView)
        newsViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: AppTab.news.rawValue)
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: AppTab.search.rawValue)
        
        let articlesView = ArticlesView(
            onWriteTap: { [weak self] in
                self?.showArticleWrite()
            }
        )
        let articleViewController = UIHostingController(rootView: articlesView)
        articleViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "pencil.line"), tag: AppTab.article.rawValue)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: AppTab.profile.rawValue)
        profileViewController.onLogout = onLogout
        profileViewController.onShowInterests = { [weak self] in
            self?.showInterests()
        }
        profileViewController.onSettings = { [weak self, weak profileViewController] in
            self?.showSettings(from: profileViewController)
        }
        profileViewController.onShowFavorites = { [weak self] in
            self?.showFavorites()
        }
        
        tabBarController.viewControllers = [homeViewController, newsViewController, searchViewController, articleViewController, profileViewController,]
        navigationController.setViewControllers([tabBarController], animated: true)
        
    }
    
    //MARK: - Navigation Functions
    private func showInterests() {
        let interestsViewController = InterestsPageViewController()
        navigationController.pushViewController(interestsViewController, animated: true)
    }
    
    private func showSettings(from profileViewController: ProfileViewController?) {
        let currentUser = profileViewController?.currentUser
        let currentProfileImage = profileViewController?.currentProfileImage
        let profileSettingsViewController = ProfileSettingsViewController(
            initialUser: currentUser,
            initialProfileImage: currentProfileImage
        )
        navigationController.pushViewController(profileSettingsViewController, animated: true)
    }
    
    private func showBestOfNewsDetails(_ news: BestOfNews) {
        let bestOfNewsDetailView = BestOfNewsDetailView(
            news: news,
            onBestOfNewsTap: { [weak self] news in
                self?.showBestOfNewsDetails(news)
            }
        )
        let bestOfNewsDetailViewController = UIHostingController(rootView: bestOfNewsDetailView)
        navigationController.pushViewController(bestOfNewsDetailViewController, animated: true)
    }
    
    private func showNewsDetails(_ news: News) {
        let newsDetailView = NewsDetailView(
            news: news,
            onNewsTap: { [weak self] news in
                self?.showNewsDetails(news)
            }
        )
        let newsDetailViewController = UIHostingController(rootView: newsDetailView)
        navigationController.pushViewController(newsDetailViewController, animated: true)
    }
    
    private func switchToNewsTab() {
        tabBarController?.selectedIndex = AppTab.news.rawValue
    }
    
    private func showFavorites() {
        let favoritesView = FavoritesView(
            onNewsTap: { [weak self] news in
                self?.showNewsDetails(news)
            }
        )
        let favoritesViewController = UIHostingController(rootView: favoritesView)
        navigationController.pushViewController(favoritesViewController, animated: true)
    }
    
    private func showQuizDetails(_ quiz: Quiz) {
        let quizView = QuizView(
            quiz: quiz,
            onQuizTap: { [weak self] quiz in
                self?.showQuizDetails(quiz)
            },
            onStartQuiz: { [weak self] quiz in
                self?.showQuizDetailsView(quiz)
            }
        )
        let quizViewController = UIHostingController(rootView: quizView)
        navigationController.pushViewController(quizViewController, animated: true)
    }
    
    private func showQuizDetailsView(_ quiz: Quiz) {
        let quizDetailsView = QuizDetailsView(quiz: quiz, onFinish: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        let quizDetailsViewController = UIHostingController(rootView: quizDetailsView)
        navigationController.pushViewController(quizDetailsViewController, animated: true)
    }

    private func showArticleWrite() {
        let articleWriteView = ArticleWriteView(onFinish: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        let articleWriteViewController = UIHostingController(rootView: articleWriteView)
        navigationController.pushViewController(articleWriteViewController, animated: true)
    }
}
