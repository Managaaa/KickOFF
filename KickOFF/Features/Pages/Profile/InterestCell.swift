import UIKit

class InterestCell: UICollectionViewCell {
    //MARK: - Properties
    private let interestCircleView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "circle"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
            interestCircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
