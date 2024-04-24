//
//  GradientView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData

struct GradientView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @ObservedObject var viewModel: GradientViewModel
    @State private var lastShakeTime = Date.distantPast
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(gradient: SwiftUI.Gradient(colors: [viewModel.startColour, viewModel.endColour]), startPoint: UnitPoint(x: cos(viewModel.angle), y: sin(viewModel.angle)), endPoint: UnitPoint(x: cos(viewModel.angle + .pi), y: sin(viewModel.angle + .pi))))
                .onShake {
                    viewModel.generateNewGradient(gradients: gradients, context: context)
                }
            
        }
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            SaveView(viewModel: viewModel)
                .padding(.trailing)
                .padding(.top)
        }
        .overlay(alignment: .top) {
            if viewModel.isSaved {
                MessageView(message: "Saved to Photos", image: "checkmark.circle")
                    .transition(.scale)
                    .padding(.top)
            }
            if viewModel.isCopied {
                MessageView(message: "Copied to Clipboard", image: "checkmark.circle")
                    .transition(.scale)
                    .padding(.top)
            }
        }
    }
}

#Preview {
    GradientView(viewModel: GradientViewModel())
}
