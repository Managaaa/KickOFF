import SwiftUI

struct AnswerOptionView: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if showResult {
            if isCorrect {
                return Color.correct
            } else if isSelected && !isCorrect {
                return (Color.incorrect)
            } else {
                return Color.customGray
            }
        } else {
            return isSelected ? Color.customGray.opacity(0.5) : Color.customGray
        }
    }
    
    private var borderColor: Color {
        if showResult {
            if isCorrect {
                return Color.green
            } else if isSelected && !isCorrect {
                return Color.red
            } else {
                return Color.gray.opacity(0.3)
            }
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    var body: some View {
        Button {
            if !showResult {
                onTap()
            }
        } label: {
            HStack {
                Text(answer)
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if showResult {
                    if isCorrect {
                        Image(.correct)
                            .resizable()
                            .frame(width: 24, height: 24)
                    } else if isSelected && !isCorrect {
                        Image(.incorrect)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(16)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .disabled(showResult)
    }
}
