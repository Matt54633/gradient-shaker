//
//  ColorExtension.swift
//  Gradients
//
//  Created by Matt Sullivan on 24/04/2024.
//

import Foundation
import SwiftUI

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    func toHexString() -> String {
        let components = cgColor.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = ((components?.count ?? 0) > 2 ? components?[2] : g) ?? 0
        let hexString = String(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
}
