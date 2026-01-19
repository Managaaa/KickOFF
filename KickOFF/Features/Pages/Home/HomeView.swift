import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    var onBestOfNewsTap: ((BestOfNews) -> Void)?
    var onNewsTap: ((News) -> Void)?
    var onSeeAllTap: (() -> Void)?
    
    init(viewModel: HomeViewModel = HomeViewModel(), onBestOfNewsTap: ((BestOfNews) -> Void)? = nil, onNewsTap: ((News) -> Void)? = nil, onSeeAllTap: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBestOfNewsTap = onBestOfNewsTap
        self.onNewsTap = onNewsTap
        self.onSeeAllTap = onSeeAllTap
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 30) {
                            Image(.logo)
                                .resizable()
                                .frame(width: 150, height: 20)
                            
                            Text("Best Of 2025")
                                .foregroundStyle(.white)
                                .font(FontType.black.swiftUIFont(size: 20))
                            
                        }
                        
                        Text("2025 წლის გამორჩეული ამბები")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(FontType.medium.swiftUIFont(size: 12))
                        
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else {
                            GeometryReader { geometry in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.bestOfNews) { news in
                                            BestOfsCardView(title: news.title, subtitle: news.subtitle, image: news.imageUrl)
                                                .frame(width: geometry.size.width)
                                                .onTapGesture {
                                                    onBestOfNewsTap?(news)
                                                }
                                        }
                                    }
                                    .scrollTargetLayout()
                                }
                                .scrollTargetBehavior(.viewAligned)
                                .scrollClipDisabled()
                            }
                            .frame(height: 300)
                        }
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("ახალი ამბები")
                            .foregroundStyle(.white)
                            .font(FontType.black.swiftUIFont(size: 20))
                        
                        Text("გაეცანი მსოფლიო სპორტის სიახლეებს")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(FontType.medium.swiftUIFont(size: 12))
                        
                        if viewModel.isLoading {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 300)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(viewModel.news) { news in
                                    NewsCardView(title: news.title, subtitle: news.subtitle, image: news.imageUrl, date: viewModel.timeAgo(from: news.date))
                                        .onTapGesture {
                                            onNewsTap?(news)
                                        }
                                }
                            }
                        }
                        
                        VStack(alignment: .center) {
                            Button {
                                onSeeAllTap?()
                            } label: {
                                Text("ნახე ყველა...")
                                    .font(FontType.medium.swiftUIFont(size: 12))
                                    .foregroundStyle(.customGreen)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("ქვიზები")
                            .foregroundStyle(.white)
                            .font(FontType.black.swiftUIFont(size: 20))
                        
                        Text("შეამოწმე შენი სპორტული ცოდნა")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(FontType.medium.swiftUIFont(size: 12))
                        
                        QuizCardView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 2)
            }
        }
    }
}

#Preview {
    HomeView()
}
