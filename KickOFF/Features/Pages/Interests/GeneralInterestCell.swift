import UIKit
import Kingfisher

class GeneralInterestCell: UICollectionViewCell {
    //MARK: - Properties
    private let interestCircleView: UIImageView = {
        let image = UIImageView(image: UIImage(named: ""))
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let interestTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ქართული სპორტი"
        label.font = FontType.bold.uiFont(size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var onToggleSelection: (() -> Void)?
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupUI() {
        configureInterestCircleView()
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func plusButtonTapped() {
        onToggleSelection?()
    }
    
    private func configureInterestCircleView() {
        [interestCircleView, interestTitleLabel, plusButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            interestCircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            interestCircleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            interestCircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            interestCircleView.widthAnchor.constraint(equalToConstant: 70),
            
            interestTitleLabel.leadingAnchor.constraint(equalTo: interestCircleView.trailingAnchor, constant: 20),
            interestTitleLabel.centerYAnchor.constraint(equalTo: interestCircleView.centerYAnchor),
            interestTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: interestCircleView.centerYAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with interest: Interest, isSelected: Bool, onToggle: @escaping () -> Void) {
        interestTitleLabel.text = interest.title
        onToggleSelection = onToggle
        
        let imageName = isSelected ? "minusbutton" : "plusbutton"
        plusButton.setImage(UIImage(named: imageName), for: .normal)
        
        interestCircleView.loadInterestImage(from: interest.imageUrl, size: 70, placeholder: UIImage(named: "circle"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onToggleSelection = nil
        interestCircleView.kf.cancelDownloadTask()
        interestCircleView.image = nil
    }
    
}

#Preview {
    InterestsPageViewController()
}
