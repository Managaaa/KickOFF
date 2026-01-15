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
        let homeView = HomeView(viewModel: homeViewModel)
        let homeViewController = UIHostingController(rootView: homeView)
        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: AppTab.home.rawValue)
        
        let newsViewController = UIViewController()
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
        let interestsNavigationController = UINavigationController(rootViewController: interestsViewController)
        interestsNavigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = interestsNavigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        tabBarController?.present(interestsNavigationController, animated: true)
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
}
