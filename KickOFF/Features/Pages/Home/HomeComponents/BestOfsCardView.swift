import SwiftUI

struct BestOfsCardView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customGray
                .frame(height: 300)
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 12) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 180)
                
                Text("Best of 2025: წლის საუკეთესო ტრანსფერები")
                    .font(FontType.medium.swiftUIFont(size: 14))
                    .foregroundColor(.customGreen)
                
                Text("წლის საუკეთესო გადაგება ასაში და მისი გავლენა")
                    .font(FontType.medium.swiftUIFont(size: 16))
                    .foregroundColor(.white)
            }
            .padding(12)
        }
    }
}

#Preview {
    HomeView()
}
