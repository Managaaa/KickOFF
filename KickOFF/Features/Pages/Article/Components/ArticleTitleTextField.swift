import SwiftUI

struct ArticleTitleTextFieldView: View {
    @Binding var text: String

    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text("ჩაწერე არტიკლის სათაური...")
                .font(FontType.medium.swiftUIFont(size: 12))
                .foregroundStyle(Color.gray)
        )
        .textFieldStyle(.plain)
        .font(FontType.medium.swiftUIFont(size: 14))
        .foregroundStyle(.white)
        .tint(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customGray, lineWidth: 1)
        )
    }
}
