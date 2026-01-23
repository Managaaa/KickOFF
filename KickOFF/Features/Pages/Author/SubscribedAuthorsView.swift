import SwiftUI

struct SubscribedAuthorsView: View {
    @ObservedObject private var viewModel = AuthorViewModel.shared
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 0) {
                    Text("გამოწერილი")
                        .font(FontType.black.swiftUIFont(size: 20))
                        .foregroundStyle(.white)
                    Text("ავტორები")
                        .font(FontType.black.swiftUIFont(size: 20))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 70)
                .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding()
                } else if viewModel.subscribedAuthors.isEmpty {
                    Text("არ გყავს გამოწერილი ავტორები")
                        .font(FontType.medium.swiftUIFont(size: 14))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.subscribedAuthors) { author in
                                SubscribedAuthorCardView(author: author)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }
}
