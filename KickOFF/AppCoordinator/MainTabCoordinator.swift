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
            }
        )
        let homeViewController = UIHostingController(rootView: homeView)
        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: AppTab.home.rawValue)
        
        let newsViewModel = NewsViewModel()
        let newsView = NewsView(viewModel: newsViewModel)
        let newsViewController = UIHostingController(rootView: newsView)
        newsViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: AppTab.news.rawValue)
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: AppTab.search.rawValue)
        
        let articleViewController = UIViewController()
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
        let bestOfNewsView = BestOfNewsView(news: news)
        let bestOfNewsViewController = UIHostingController(rootView: bestOfNewsView)
        navigationController.pushViewController(bestOfNewsViewController, animated: true)
    }
}
