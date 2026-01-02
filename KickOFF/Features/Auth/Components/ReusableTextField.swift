import SwiftUI

struct ReusableTextField: View {
    let placeholder: String
    let isSecure: Bool
    @Binding var text: String
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text, prompt: Text(placeholder)
                            .font(.custom("TBCContracticaCAPS-Medium", size: 14))
                            .foregroundStyle(.gray)
                        )
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder)
                            .font(.custom("TBCContracticaCAPS-Medium", size: 14))
                            .foregroundStyle(.gray)
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
                .foregroundStyle(.gray.opacity(0.6))
        }
    }
}


#Preview {
    ReusableTextField(placeholder: "სახელი*", isSecure: true, text: .constant(""),)
}
