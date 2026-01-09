import UIKit

class GeneralInterestCell: UICollectionViewCell {
    //MARK: - Properties
    private let interestCircleView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "circle"))
        image.contentMode = .scaleAspectFit
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
        button.setImage(UIImage(named: "plusbutton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
}

#Preview {
    InterestsPageViewController()
}
