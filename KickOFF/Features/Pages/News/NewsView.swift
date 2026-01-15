import SwiftUI

struct NewsView: View {
    @StateObject var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel = NewsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ახალი ამბები")
                    .font(FontType.black.swiftUIFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else {
                            ForEach(viewModel.news) { news in
                                NewsCardView(title: news.title, subtitle: news.subtitle, image: news.imageUrl, date: viewModel.timeAgo(from: news.date))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    NewsView()
}
