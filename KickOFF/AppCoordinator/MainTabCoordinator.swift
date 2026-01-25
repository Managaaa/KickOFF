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
            onNewsTap: { [weak self] news, viewModel in
                self?.showNewsDetails(news, viewModel: viewModel)
            },
            onQuizTap: { [weak self] quiz in
                self?.showQuizDetails(quiz)
            },
            onSeeAllTap: { [weak self] in
                self?.switchToNewsTab()
            },
            onAuthorCardTap: { [weak self] author in
                self?.showAuthorProfileView(author)
            }
        )
        let homeViewController = UIHostingController(rootView: homeView)
        let homeTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeTabBarItem.tag = AppTab.home.rawValue
        homeViewController.tabBarItem = homeTabBarItem
        
        let newsViewModel = NewsViewModel()
        let newsView = NewsView(
            viewModel: newsViewModel,
            onNewsTap: { [weak self] news, viewModel in
                self?.showNewsDetails(news, viewModel: viewModel)
            })
        let newsViewController = UIHostingController(rootView: newsView)
        let newsTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))
        newsTabBarItem.tag = AppTab.news.rawValue
        newsViewController.tabBarItem = newsTabBarItem
        
        let searchView = SearchView(
            onNewsTap: { [weak self] news in
                self?.showNewsDetails(news, viewModel: nil)
            },
            onBestOfNewsTap: { [weak self] news in
                self?.showBestOfNewsDetails(news)
            },
            onQuizTap: { [weak self] quiz in
                self?.showQuizDetails(quiz)
            },
            onArticleTap: { [weak self] article in
                self?.showArticleDetails(article)
            },
            onAuthorTap: { [weak self] author in
                self?.showAuthorProfileView(author)
            }
        )
        let searchViewController = UIHostingController(rootView: searchView)
        let searchTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        searchTabBarItem.tag = AppTab.search.rawValue
        searchViewController.tabBarItem = searchTabBarItem
        
        let articlesView = ArticlesView(
            onWriteTap: { [weak self] in
                self?.showArticleWrite()
            },
            onArticleCardTap: { [weak self] article in
                self?.showArticleDetails(article)
            }
        )
        let articleViewController = UIHostingController(rootView: articlesView)
        let articleTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "pencil"), selectedImage: UIImage(systemName: "pencil.line"))
        articleTabBarItem.tag = AppTab.article.rawValue
        articleViewController.tabBarItem = articleTabBarItem
        
        let profileViewController = ProfileViewController()
        let profileTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        profileTabBarItem.tag = AppTab.profile.rawValue
        profileViewController.tabBarItem = profileTabBarItem
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
        profileViewController.onShowMyArticles = { [weak self] in
            self?.showMyArticles()
        }
        profileViewController.onShowSubscribedAuthors = { [weak self] in
            self?.showSubscribedAuthors()
        }
        
        tabBarController.viewControllers = [homeViewController, newsViewController, searchViewController, articleViewController, profileViewController,]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        let customGreen = UIColor(named: "customGreen") ?? UIColor.systemGreen
        appearance.stackedLayoutAppearance.selected.iconColor = customGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: customGreen]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
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
    
    private func showNewsDetails(_ news: News, viewModel: HomeViewModel?) {
        let newsDetailView = NewsDetailView(
            viewModel: viewModel ?? HomeViewModel(),
            news: news,
            onNewsTap: { [weak self] news, viewModel in
                self?.showNewsDetails(news, viewModel: viewModel)
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
            onNewsTap: { [weak self] news, viewModel in
                self?.showNewsDetails(news, viewModel: viewModel)
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
    
    private func showArticleDetails(_ article: Article) {
        let articleDetailsView = ArticleDetailView(article: article) { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let articleDetailViewController = UIHostingController(rootView: articleDetailsView)
        navigationController.pushViewController(articleDetailViewController, animated: true)
    }
    
    private func showMyArticles() {
        let myArticlesView = MyArticlesView(
            onArticleCardTap: { [weak self] article in
                self?.showArticleDetails(article)
            }
        )
        let myArticlesViewController = UIHostingController(rootView: myArticlesView)
        navigationController.pushViewController(myArticlesViewController, animated: true)
    }
    
    private func showSubscribedAuthors() {
        let subscribedAuthorsView = SubscribedAuthorsView(
            onAuthorCardTap: { [weak self] author in
                self?.showAuthorProfileView(author)
            }
        )
        let subscribedAuthorsViewController = UIHostingController(rootView: subscribedAuthorsView)
        navigationController.pushViewController(subscribedAuthorsViewController, animated: true)
    }
    
    private func showAuthorProfileView(_ author: Author) {
        let authorProfileView = AuthorProfileView(
            author: author,
            onArticleCardTap: { [weak self] article in
                self?.showArticleDetails(article)
            }
        )
        let authorProfileViewController = UIHostingController(rootView: authorProfileView)
        navigationController.pushViewController(authorProfileViewController, animated: true)
        
    }
}
