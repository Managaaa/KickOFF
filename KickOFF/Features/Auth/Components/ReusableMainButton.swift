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
                .background(
                    Color.customGreen
                        .frame(width: 265, height: 50)
                        .cornerRadius(10)
                )
        }
    }
}

#Preview {
    ReusableMainButton(title: "ავტორიზაცია", action: {} )
}
