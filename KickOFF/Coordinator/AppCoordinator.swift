import UIKit
import FirebaseAuth

final class AppCoordinator: Coordinator {
    //MARK: - Properties
    var navigationController: UINavigationController
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainTabCoordinator?
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    //MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Auth and TabBar views coordinator handle
    func start() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let handle = self.authStateHandle {
                Auth.auth().removeStateDidChangeListener(handle)
                self.authStateHandle = nil
            }
            
            if user != nil {
                self.showMain()
            } else {
                self.showAuth()
            }
        }
    }
    
    private func showAuth() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        
        coordinator.onAuthFinished = { [weak self] in
            self?.showMain()
        }
        
        authCoordinator = coordinator
        coordinator.start()
    }
    
    private func showMain() {
        let coordinator = MainTabCoordinator(navigationController: navigationController)
        
        coordinator.onLogout = { [weak self] in
            self?.showAuth()
        }
        
        mainCoordinator = coordinator
        coordinator.start()
    }
}
