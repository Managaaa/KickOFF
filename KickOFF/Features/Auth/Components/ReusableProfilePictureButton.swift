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
                    } else if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image("changephoto")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    } else {
                        Image("changephoto")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(Circle())
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
