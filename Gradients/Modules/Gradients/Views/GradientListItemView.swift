//
//  GradientListItemView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI

struct GradientListItemView: View {
    let startColour: Color
    let endColour: Color
    let angle: Double
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(gradient: Gradient(colors: [startColour, endColour]), startPoint: UnitPoint(x: cos(angle), y: sin(angle)), endPoint: UnitPoint(x: cos(angle + .pi), y: sin(angle + .pi))))
            .frame(height: 70)
            .padding(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.clear)
                    .stroke(.white, lineWidth: 5)
                    .padding(10)
            )
        
    }
}

#Preview {
    GradientListItemView(startColour: .blue, endColour: .green, angle: 360.0, viewModel: GradientViewModel())
}


