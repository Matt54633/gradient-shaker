//
//  GradientView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData
import SWTools

struct GradientView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.isOnMac) var isOnMac
    @ObservedObject var viewModel: GradientViewModel
    @State private var lastShakeTime = Date.distantPast
    @State private var shakeOffset: CGFloat = 0    
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(gradient: SwiftUI.Gradient(colors: [viewModel.startColour, viewModel.endColour]), startPoint: UnitPoint(x: cos(viewModel.angle), y: sin(viewModel.angle)), endPoint: UnitPoint(x: cos(viewModel.angle + .pi), y: sin(viewModel.angle + .pi))))
                .onShake {
                    viewModel.generateNewGradient(gradients: gradients, context: context)
                }
                .onTapGesture {
                    if isOnMac {
                        viewModel.generateNewGradient(gradients: gradients, context: context)
                        
                        viewModel.shake($shakeOffset)
                    }
                }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            if sizeClass == .compact {
                SaveView(viewModel: viewModel)
                    .padding(.trailing)
                    .padding(.top)
            }
        }
        .overlay(alignment: .top) {
            if viewModel.isSaved {
                MessageView(message: "Saved to Photos", image: "checkmark.circle", systemImage: true)
                    .transition(.scale)
                    .padding(.top, sizeClass == .compact ? 15 : 0)
            }
            
            if viewModel.isErrored {
                MessageView(message: "Failed to Save", image: "exclamationmark.circle", systemImage: true)
                    .transition(.scale)
                    .padding(.top, sizeClass == .compact ? 15 : 0)
            }
            
            if viewModel.isCopied {
                MessageView(message: "Copied to Clipboard", image: "checkmark.circle", systemImage: true)
                    .transition(.scale)
                    .padding(.top, sizeClass == .compact ? 15 : 0)
            }
        }
        .overlay(alignment: .bottom) {
            if sizeClass == .regular {
                MessageView(message: isOnMac ? "Click to Generate!" : "Shake to Generate!", image: "shaker", systemImage: false)
                    .onTapGesture {
                        if isOnMac {
                            viewModel.generateNewGradient(gradients: gradients, context: context)
                            
                            viewModel.shake($shakeOffset)
                        }
                    }
                    .padding(.bottom, isOnMac ? 15 : 0)
                    .offset(x: shakeOffset)
                    .onShake {
                        viewModel.shake($shakeOffset)
                    }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if sizeClass == .regular {
                SaveView(viewModel: viewModel)
                    .padding(.trailing)
                    .padding(.bottom, isOnMac ? 15 : 0)
            }
        }
    }
}

#Preview {
    GradientView(viewModel: GradientViewModel())
}

