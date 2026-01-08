import UIKit

class InterestsPageViewController: UIViewController {
    //MARK: - Properties
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ინტერესები"
        label.font = FontType.bold.uiFont(size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "აირჩიე შენზე მორგებული ინტერესები"
        label.font = FontType.regular.uiFont(size: 14)
        label.textColor = .customGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interestsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 70, height: 70)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
    }
    
    private func setupUI() {
        configurePageTitleLabel()
        configureSubTitleLabel()
        configureInterestCollectionView()
    }
    
    private func configurePageTitleLabel() {
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureSubTitleLabel() {
        view.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 20),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureInterestCollectionView() {
        view.addSubview(interestsCollectionView)
        
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        
        interestsCollectionView.register(GeneralInterestCell.self, forCellWithReuseIdentifier: "GeneralInterestCell")
        
        NSLayoutConstraint.activate([
            interestsCollectionView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            interestsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            interestsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            interestsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension InterestsPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralInterestCell", for: indexPath) as? GeneralInterestCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}

#Preview {
    InterestsPageViewController()
}
