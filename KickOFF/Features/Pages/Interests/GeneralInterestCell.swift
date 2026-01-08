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
        contentView.addSubview(interestCircleView)
        
        NSLayoutConstraint.activate([
            interestCircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            interestCircleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            interestCircleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            interestCircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            interestTitleLabel.leadingAnchor.constraint(equalTo: interestCircleView.trailingAnchor, constant: 20),
            interestTitleLabel.centerXAnchor.constraint(equalTo: interestCircleView.centerXAnchor)
        ])
    }
    
}
