//
//  ShakeDisplayView.swift
//  Gradients
//
//  Created by Matt Sullivan on 23/04/2024.
//

import SwiftUI

struct ShakeDisplayView: View {
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            
            Image("shaker")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .padding(.trailing, 5)
            
            Text("Shake to Generate!")
                .font(.title3)
                .fontDesign(.rounded)
            
        }
        .foregroundStyle(.white)
        .fontWeight(.bold)
        .offset(x: shakeOffset)
        .onShake {
            
            withAnimation(.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true)) {
                shakeOffset = 10
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    shakeOffset = 0
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ShakeDisplayView()
}

