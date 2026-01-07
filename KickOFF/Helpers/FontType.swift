import SwiftUI
import UIKit

public enum FontType {
    case black
    case bold
    case book
    case light
    case medium
    case regular
    
    var fontName: String {
        switch self {
        case .black:
            return "TBCContracticaCAPS-Black"
        case .bold:
            return "TBCContracticaCAPS-Bold"
        case .book:
            return "TBCContracticaCAPS-Book"
        case .light:
            return "TBCContracticaCAPS-Light"
        case .medium:
            return "TBCContracticaCAPS-Medium"
        case .regular:
            return "TBCContracticaCAPS-Regular"
        }
    }
    
    func swiftUIFont(size: CGFloat) -> Font {
        return .custom(fontName, size: size)
    }
    
    func uiFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

