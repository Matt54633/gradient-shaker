//
//  Gradient.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class GradientModel: Identifiable {
    var id: String = ""
    var startColour: String = ""
    var endColour: String = ""
    var angle: Double = 0
    var isFavourite: Bool = false
    
    init(startColour: String, endColour: String, angle: Double, isFavourite: Bool) {
        self.id = UUID().uuidString
        self.startColour = startColour
        self.endColour = endColour
        self.angle = angle
        self.isFavourite = isFavourite
    }
}
