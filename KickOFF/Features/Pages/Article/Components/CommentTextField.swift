import SwiftUI

struct CommentTextField: View {
    @Binding var text: String
    var isDisabled: Bool = false
    var onSend: () -> Void

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isDisabled
    }

    var body: some View {
        HStack(spacing: 12) {
            TextField(
                "",
                text: $text,
                prompt: Text("დატოვე კომენტარი")
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
            .disabled(isDisabled)

            Button {
                onSend()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? .customGreen : .gray)
            }
            .disabled(!canSend)
        }
    }
}
