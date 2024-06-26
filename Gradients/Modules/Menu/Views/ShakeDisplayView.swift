//
//  ShakeDisplayView.swift
//  Gradients
//
//  Created by Matt Sullivan on 23/04/2024.
//

import SwiftUI
import SWTools

struct ShakeDisplayView: View {
    @State private var shakeOffset: CGFloat = 0
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        HStack {
            
            Image("shaker")
                .resizable()
                .scaledToFit()
                .frame(height: 37.5)
            
            Text("Shake to Generate!")
                .font(.title3)
                .fontDesign(.rounded)
            
        }
        .foregroundStyle(.white)
        .fontWeight(.bold)
        .offset(x: shakeOffset)
        .onShake {
            viewModel.shake($shakeOffset)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ShakeDisplayView(viewModel: GradientViewModel())
}

