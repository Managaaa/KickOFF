import SwiftUI

func orBorderView() -> some View {
    HStack(spacing: 10) {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.white.opacity(0.6))
        
        Text("ან")
            .font(.custom("TBCContracticaCAPS-Regular", size: 12))
            .foregroundColor(.white.opacity(0.6))
        
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.white.opacity(0.6))
    }
}
