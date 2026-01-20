import SwiftUI

struct ProfileMenuListView: View {
    var onFavoritesTap: (() -> Void)?
    var onSubscribedTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            MenuItemRow(icon: "heart", title: "ფავორიტები", isLast: false
            ) {
                onFavoritesTap?()
            }
            
            MenuItemRow(icon: "bell", title: "გამოწერილი", isLast: true
            ) {
                onSubscribedTap?()
            }
        }
        .background(Color.customGray)
        .cornerRadius(12)
    }
}

struct MenuItemRow: View {
    let icon: String
    let title: String
    let isLast: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .frame(width: 20)
                
                Text(title)
                    .font(FontType.medium.swiftUIFont(size: 16))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        
        if !isLast {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
        }
    }
}

#Preview {
    ProfileMenuListView()
        .padding()
        .background(Color.customBackground)
}
