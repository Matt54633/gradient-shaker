//
//  SaveView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI

struct SaveView: View {
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        Button {
            viewModel.captureSnapshot()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } label: {
            
            Image(systemName: "arrow.down.circle")
                .font(.title)
                .foregroundStyle(.white)
            
        }
        .padding(7.5)
        .background(Circle().fill(.ultraThinMaterial))
        
    }
}

#Preview {
    SaveView(viewModel: GradientViewModel())
}
