import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    var onLogout: (() -> Void)?
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .customBackground
        title = "Profile"
        configureLogOutButton()
    }
    
    private func configureLogOutButton() {
        
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onLogoutSuccess = { [weak self] in
            self?.onLogout?()
        }
        
        viewModel.onLogoutError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "შეცდომა",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "კარგი", style: .default))
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    @objc private func logoutButtonTapped() {
        viewModel.logout()
    }
}

