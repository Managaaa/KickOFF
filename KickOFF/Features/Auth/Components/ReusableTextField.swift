import SwiftUI

struct ReusableTextField: View {
    let placeholder: String
    let isSecure: Bool
    @Binding var text: String
    var errorMessage: String? = nil
    var showError: Bool = false
    
    @State private var isPasswordVisible = false
    
    private var placeholderColor: Color {
        showError ? .red : .gray
    }
    
    private var borderColor: Color {
        showError ? .red : .gray.opacity(0.6)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text, prompt: Text(placeholder)
                            .font(.custom("TBCContracticaCAPS-Medium", size: 14))
                            .foregroundStyle(placeholderColor)
                        )
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder)
                            .font(.custom("TBCContracticaCAPS-Medium", size: 14))
                            .foregroundStyle(placeholderColor)
                        )
                    }
                }
                .foregroundColor(.white)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(borderColor)
            
            if showError, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.custom("TBCContracticaCAPS-Medium", size: 10))
                    .foregroundStyle(.red)
                    .padding(.top, 2)
            }
        }
    }
}


#Preview {
    ReusableTextField(placeholder: "სახელი*", isSecure: true, text: .constant(""),)
}
