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
    
    //MARK: - Init
    init(navigationController: UINavigationController, selectedTab: AppTab? = nil) {
        self.navigationController = navigationController
        self.selectedTab = selectedTab
    }
    
    //MARK: - TabBarPages
    func start() {
        let tabBarController = UITabBarController()
        
        let homeViewController = UIViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: AppTab.home.rawValue)
        
        let newsViewController = UIViewController()
        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: AppTab.news.rawValue)
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: AppTab.search.rawValue)
        
        let articleViewController = UIViewController()
        articleViewController.tabBarItem = UITabBarItem(title: "Article", image: UIImage(systemName: "pencil.line"), tag: AppTab.article.rawValue)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: AppTab.profile.rawValue)
        profileViewController.onLogout = onLogout
        
        tabBarController.viewControllers = [homeViewController, newsViewController, searchViewController, articleViewController, profileViewController,]
        navigationController.setViewControllers([tabBarController], animated: true)
        
    }
}
