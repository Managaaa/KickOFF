import UIKit
import Kingfisher

extension UIImageView {
    //MARK: - Kingfisher uiimages handler
    func loadProfilePicture(from urlString: String?, size: CGFloat = 70, placeholder: UIImage? = nil) {
        let placeholderImage = placeholder ?? UIImage(named: "pfp")
        let targetSize = CGSize(width: size, height: size)
        
        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        let processor = ResizingImageProcessor(referenceSize: targetSize, mode: .aspectFill)
        
        self.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
    }
    
    func loadInterestImage(from urlString: String?, size: CGFloat = 70, placeholder: UIImage? = nil) {
        let placeholderImage = placeholder ?? UIImage(named: "circle")
        let targetSize = CGSize(width: size, height: size)
        
        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        let processor = ResizingImageProcessor(referenceSize: targetSize, mode: .aspectFill)
        
        self.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
    }
}
