import SwiftUI

struct ArticleBodyTextEditorView: View {
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text("დაწერე შენი სპორტული ფიქრი...")
                    .font(FontType.medium.swiftUIFont(size: 12))
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }

            TextEditor(text: $text)
                .font(FontType.medium.swiftUIFont(size: 14))
                .foregroundStyle(.white)
                .tint(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .frame(minHeight: 180)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.customGray, lineWidth: 1)
        )
    }
}
