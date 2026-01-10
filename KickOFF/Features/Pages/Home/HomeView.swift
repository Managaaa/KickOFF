import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.customBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Best Of 2025")
                            .foregroundStyle(.white)
                            .font(FontType.black.swiftUIFont(size: 20))
                        
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
                            ForEach(viewModel.news) { news in
                                NewsCardView(title: news.title, subtitle: news.subtitle, image: news.imageUrl, date: viewModel.timeAgo(from: news.date))
                            }
                        }
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
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    HomeView()
}
