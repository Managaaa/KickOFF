# KickOFF


![iOS](https://img.shields.io/badge/iOS-17.6%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![UIKit](https://img.shields.io/badge/UI-UIKit%20%2B%20SwiftUI-purple)
![Architecture](https://img.shields.io/badge/Architecture-Coordinator%20%2B%20MVVM-success)
![SPM](https://img.shields.io/badge/Dependency-SPM-black)
![FireBase](https://img.shields.io/badge/DataBase-FireBase-brightgreen)

## About

KickOFF is an iOS application designed to deliver comprehensive sports news and content to Georgian-speaking users. The application provides a platform for sports enthusiasts to stay updated with the latest news, read and write articles, test their knowledge through interactive quizzes, and follow their favorite sports authors. Built with a focus on user engagement and community interaction, KickOFF combines news aggregation, user-generated content, and educational quiz features to create a complete sports media experience.

## Target Audiance

- Sports enthusiasts who want to stay updated with the latest sports news
- Users interested in reading and writing sports-related articles
- People who enjoy testing their sports knowledge through quizzes
- Those who want to follow and subscribe to favorite sports authors
- Georgian-speaking users seeking localized sports content

## Features

- **News Feed** - Latest sports news with categorized content and "Best Of" highlights
- **Article System** - Read articles, write your own, and engage with comments and likes
- **Interactive Quizzes** - Test your sports knowledge with multiple-choice questions and track your progress
- **Author Profiles** - Follow and subscribe to favorite sports authors, view their articles and statistics
- **Search Functionality** - Search across news, articles, quizzes, and authors
- **User Profiles** - Manage your account, interests, favorites, and subscribed authors
- **Comments & Engagement** - Like articles, comment, and interact with the community
- **Image Support** - Upload and display images with articles

## Tech Stack

- **SwiftUI** - Modern UI framework for declarative interface design
- **UIKit** - Core UI framework for view controllers and complex components
- **FireBase** - Secure user login, registration, and account management with Google Sign-In support, Real-time database for storing articles, news, quizzes, comments, and user data with FireStore and Cloud storage for user profile images and article photos
- **Kingfisher** - Efficient image loading and caching library
- **Combine** - Reactive programming framework for data flow and state management
- **PhotosUI** - Native photo picker integration for image selection

## Architecture

**MVVM**

- **Models** - Data structures for articles, news, quizzes, users, authors, and comments
- **Views** - SwiftUI views and UIKit view controllers for UI presentation
- **ViewModels** - Business logic and state management using Combine publishers
- **Services** - Data layer abstraction for Firebase operations (ArticleService, NewsService, QuizService, UserService, etc.)
- **Coordinators** - Navigation and flow management
- **Components** - Reusable UI components for consistent design

## Project Structure

```
KickOFF/
├── App/                    # App entry point and scene configuration
├── Coordinator/            # Navigation and flow coordinators
├── Features/               # Feature modules
│   ├── Auth/              # Authentication (Login, Registration)
│   ├── Pages/             # Main app screens
│   │   ├── Article/       # Article reading and writing
│   │   ├── Author/        # Author profiles and subscriptions
│   │   ├── Home/          # Home feed and news
│   │   ├── News/          # News listing and details
│   │   ├── Quiz/          # Quiz functionality
│   │   ├── Search/        # Search functionality
│   │   └── Profile/       # User profile and settings
├── Models/                 # Data models
├── Services/               # Service layer (Firebase integration)
├── Helpers/                # Utility classes and extensions
└── Resources/              # Assets, fonts, and configuration files
```

## Installation

1. Clone the repository
   ```bash
   git clone [repository-url]
   cd KickOFF
   ```

2. Open the project in Xcode
   ```bash
   open KickOFF.xcodeproj
   ```

3. Configure Firebase
   - The app uses Firebase services - ensure `GoogleService-Info.plist` is properly configured
   - Firebase project should have Firestore, Authentication, and Storage enabled

4. Install dependencies
   - Dependencies are managed through Swift Package Manager
   - Xcode will automatically resolve packages on first build

5. Build and run
   - Select your target device or simulator
   - Press `⌘ + R` or click the Run button
  
## Screenshots
<img src="https://github.com/user-attachments/assets/8798f093-f423-4ca4-b33d-988629065e79" width="300" />
<img src="https://github.com/user-attachments/assets/10e4ae1d-09d8-4c33-a46e-b427310e22ac" width="300" />
<img src="https://github.com/user-attachments/assets/e2d82674-3e76-439d-b2c1-90d69bea4794" width="300" />
<img src="https://github.com/user-attachments/assets/67243ddb-8f19-4295-b15b-5649dadda726" width="300" />
<img src="https://github.com/user-attachments/assets/0555d87b-44e0-44fc-b2a6-3f7e7a471ba1" width="300" />
<img src="https://github.com/user-attachments/assets/dd45fe5e-a2af-4d18-8a41-5bcaf6a2b1cb" width="300" />
<img src="https://github.com/user-attachments/assets/a65abc7c-5faa-446e-a563-b58c68877694" width="300" />
<img src="https://github.com/user-attachments/assets/e42d26a3-7524-4410-acde-f323e1b25e78" width="300" />
<img src="https://github.com/user-attachments/assets/22066fed-7274-4302-8737-5b20a7b314af" width="300" />
