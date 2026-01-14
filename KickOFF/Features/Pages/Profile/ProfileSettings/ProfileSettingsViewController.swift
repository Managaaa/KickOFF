import UIKit

class ProfileSettingsViewController: UIViewController {
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "პროფილის რედაქტირება"
        label.font = FontType.bold.uiFont(size: 20)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
    }
    
    private func setupUI() {
        configurePageTitleLabel()
    }
    
    private func configurePageTitleLabel() {
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            pageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
}
