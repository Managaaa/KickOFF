import SwiftUI
import Kingfisher

//MARK: - General kingfisher image loader for swiftui components
struct KingfisherImageLoader: View {
    let imageUrl: String?
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let contentMode: SwiftUI.ContentMode
    let placeholder: Image
    let placeholderColor: Color
    
    init(imageUrl: String?, width: CGFloat? = nil, height: CGFloat? = nil, cornerRadius: CGFloat = 0, contentMode: SwiftUI.ContentMode = .fill, placeholder: Image = Image(systemName: "photo"), placeholderColor: Color = .gray) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    var body: some View {
        Group {
            if let imageUrl = imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        placeholder
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(placeholderColor)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
                    .clipped()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(placeholderColor)
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            }
        }
    }
}

//MARK: - Handle every swiftui view image fetching
extension KingfisherImageLoader {
    static func profilePicture(imageUrl: String?, size: CGFloat = 70, placeholder: Image = Image("pfp")) -> KingfisherImageLoader {
        
        KingfisherImageLoader(
            imageUrl: imageUrl,
            width: size,
            height: size,
            cornerRadius: size / 2,
            contentMode: .fill,
            placeholder: placeholder
        )
    }
    
    static func news(imageUrl: String?, width: CGFloat? = nil, height: CGFloat? = nil, cornerRadius: CGFloat = 10, placeholder: Image = Image(systemName: "photo")) -> KingfisherImageLoader {
        
        KingfisherImageLoader(
            imageUrl: imageUrl,
            width: width,
            height: height,
            cornerRadius: cornerRadius,
            contentMode: .fill,
            placeholder: placeholder
        )
    }
}
