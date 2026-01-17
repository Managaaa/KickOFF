import UIKit
import Kingfisher

class InterestCell: UICollectionViewCell {
    //MARK: - Properties
    private let interestCircleView: UIImageView = {
        let image = UIImageView(image: UIImage(named: ""))
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
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
            interestCircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with interest: Interest) {
        interestCircleView.loadInterestImage(from: interest.imageUrl, size: 70, placeholder: UIImage(named: "circle"))
        }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        interestCircleView.kf.cancelDownloadTask()
        interestCircleView.image = nil
    }
}
