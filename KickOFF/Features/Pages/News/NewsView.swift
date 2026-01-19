import SwiftUI

struct NewsView: View {
    @StateObject var viewModel: NewsViewModel
    var onNewsTap: ((News) -> Void)?
    
    init(viewModel: NewsViewModel = NewsViewModel(), onNewsTap: ((News) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNewsTap = onNewsTap
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
                
                if !viewModel.categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(viewModel.categories) { category in
                                Button {
                                    viewModel.selectCategory(category)
                                } label: {
                                    VStack(spacing: 8) {
                                        Text(category.title)
                                            .font(FontType.light.swiftUIFont(size: 12))
                                            .foregroundStyle(
                                                viewModel.selectedCategory?.id == category.id ? .white : .gray
                                            )
                                        
                                        Rectangle()
                                            .fill(viewModel.selectedCategory?.id == category.id ? Color.customGreen : Color.clear)
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                    }
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else {
                            ForEach(viewModel.news) { news in
                                NewsCardView(title: news.title, subtitle: news.subtitle, image: news.imageUrl, date: viewModel.timeAgo(from: news.date))
                                    .onTapGesture {
                                        onNewsTap?(news)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            viewModel.fetchUserInterests()
        }
    }
}
