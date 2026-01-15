import SwiftUI

struct ProfileSettingsTextFieldsView: View {
    
    @Binding var email: String
    @Binding var name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 60) {
            ReusableTextField(placeholder: "ელფოსტა*", isSecure: false, text: $email)
            
            ReusableTextField(placeholder: "სახელი*", isSecure: false, text: $name)
        }
    }
}
