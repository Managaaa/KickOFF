import SwiftUI

struct ReusableMainButton: View {
    var title: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(FontType.bold.swiftUIFont(size: 14))
                .frame(width: 265, height: 50)
                .background(
                    Color.customGreen
                        .cornerRadius(10)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ReusableMainButton(title: "ავტორიზაცია", action: {} )
}
