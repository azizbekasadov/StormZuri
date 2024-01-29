//
//  CustomFonts.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreGraphics
import UIKit.UIFont

public enum InterFontType: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semibold = "SemiBold"
    case thin = "Thin"
    
    var fontName: String {
        return "Inter-" + self.rawValue
    }
    
    public func fontType(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-" + self.rawValue, size: size)!
    }
}
