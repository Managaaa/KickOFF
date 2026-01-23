import Foundation

struct Author: Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
    let profileImageUrl: String?
    let totalLikes: Int
    let subscribers: Int
    let articleCount: Int
}
