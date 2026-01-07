import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    var onLogout: (() -> Void)?
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "პროფილი"
        label.font = FontType.bold.uiFont(size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileCover: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cover"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let profileCoverImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "pfp"))
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "lukamanaga"
        label.font = FontType.medium.uiFont(size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usermailLabel: UILabel = {
        let label = UILabel()
        label.text = "managaluka0@gmail.com"
        label.font = FontType.regular.uiFont(size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interestTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ჩემი ინტერესები"
        label.font = FontType.black.uiFont(size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addInterestButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addInterest"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let interestCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 70, height: 70)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private var reusableButtonHostingController: UIHostingController<ReusableMainButton>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .customBackground
        configureLogOutButton()
        configurePageTitleLabel()
        configureCover()
        configureInterestTitleLabel()
        configureInterestCollectionView()
    }
    
    private func configurePageTitleLabel() {
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureCover() {
        [profileCover, profileCoverImage, usernameLabel, usermailLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileCover.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 20),
            profileCover.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileCover.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileCover.heightAnchor.constraint(equalToConstant: 105),
            
            profileCoverImage.leadingAnchor.constraint(equalTo: profileCover.leadingAnchor, constant: 16),
            profileCoverImage.topAnchor.constraint(equalTo: profileCover.topAnchor, constant: 16),
            profileCoverImage.trailingAnchor.constraint(equalTo: profileCoverImage.trailingAnchor, constant: 16),
            profileCoverImage.heightAnchor.constraint(equalToConstant: 70),
            profileCoverImage.widthAnchor.constraint(equalToConstant: 70),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileCoverImage.trailingAnchor, constant: 24),
            usernameLabel.topAnchor.constraint(equalTo: profileCover.topAnchor, constant: 38),
            usernameLabel.trailingAnchor.constraint(equalTo: profileCover.trailingAnchor, constant: -10),
            
            usermailLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            usermailLabel.trailingAnchor.constraint(equalTo: profileCover.trailingAnchor, constant: -10),
            usermailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3)
        ])
    }
    
    private func configureInterestTitleLabel() {
        view.addSubview(interestTitleLabel)
        
        NSLayoutConstraint.activate([
            interestTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            interestTitleLabel.topAnchor.constraint(equalTo: profileCover.bottomAnchor, constant: 30)
        ])
    }
    
    private func configureInterestCollectionView() {
        view.addSubview(addInterestButton)
        view.addSubview(interestCollectionView)
        
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        
        interestCollectionView.register(InterestCell.self, forCellWithReuseIdentifier: "InterestCell")
        
        NSLayoutConstraint.activate([
            addInterestButton.leadingAnchor.constraint(equalTo: interestTitleLabel.leadingAnchor),
            addInterestButton.topAnchor.constraint(equalTo: interestTitleLabel.bottomAnchor, constant: 30),
            addInterestButton.heightAnchor.constraint(equalToConstant: 70),
            addInterestButton.widthAnchor.constraint(equalToConstant: 70),
            
            interestCollectionView.leadingAnchor.constraint(equalTo: addInterestButton.trailingAnchor, constant: 20),
            interestCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            interestCollectionView.topAnchor.constraint(equalTo: addInterestButton.topAnchor),
            interestCollectionView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func configureLogOutButton() {
        let reusableButton = ReusableMainButton(title: "გასვლა") { [weak self] in
            self?.logoutButtonTapped()
        }
        
        let hostingController = UIHostingController(rootView: reusableButton)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.reusableButtonHostingController = hostingController
        
        NSLayoutConstraint.activate([
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: 265),
            hostingController.view.heightAnchor.constraint(equalToConstant: 50)
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
    private func logoutButtonTapped() {
        viewModel.logout()
    }
}

//MARK: - UI collectionview Delegate & Datasource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as? InterestCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

#Preview {
    ProfileViewController()
}
