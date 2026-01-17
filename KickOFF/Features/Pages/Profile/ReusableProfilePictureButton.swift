import SwiftUI

struct ReusableProfilePictureButton: View {
    let action: () -> Void
    var imageUrl: String? = nil
    var selectedImage: UIImage? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                action()
            } label: {
                Group {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else {
                        KingfisherImageLoader.profilePicture(imageUrl: imageUrl, size: 70, placeholder: Image("changephoto"))
                    }
                }
                
                Text("სურათის არჩევა")
                    .foregroundStyle(Color.customGreen)
                    .font(FontType.regular.swiftUIFont(size: 12))
            }
        }
    }
}

#Preview {
    ReusableProfilePictureButton(action: {})
        .background(Color.customBackground)
}
