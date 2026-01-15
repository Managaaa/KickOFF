import Foundation

enum NewsCategoryType: String, CaseIterable, Identifiable {
    case georgianSports = "ყველა"
    case ufc = "ქართული სპორტი"
    case football = "UFC"
    case basketball = "კალათბურთი"
    case other = "სხვა"
    
    var id: String { rawValue }
}
