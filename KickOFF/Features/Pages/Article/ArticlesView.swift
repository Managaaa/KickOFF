import SwiftUI

struct ArticlesView: View {
    var onWriteTap: (() -> Void)?

    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("არტიკლები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)

            Button {
                onWriteTap?()
            } label: {
                Image(.write)
                    .resizable()
                    .frame(width: 54, height: 54)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 30)
            .padding(.bottom, 20)
        }
    }
}
