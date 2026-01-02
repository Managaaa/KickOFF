import UIKit
import SwiftUI

final class AuthCoordinator: Coordinator {
    //MARK: - Properties
    var navigationController: UINavigationController
    var onAuthFinished: ((() -> Void)?)
    
    //MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Navigation Functions
    func start() {
        showLogin()
    }
    
    private func showLogin() {
        let viewModel = LoginViewModel()
        let view = LoginView(viewModel: viewModel, onLoginSuccess: { [weak self] in
            self?.onAuthFinished?()
        }, onRegister: { [weak self] in
            self?.showRegister()
        })
        let vc = UIHostingController(rootView: view)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showRegister() {
        let viewModel = RegistrationViewModel()
        let view = RegistrationView(viewModel: viewModel, onLogin: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}
