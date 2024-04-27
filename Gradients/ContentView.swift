//
//  ContentView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isPresented: Bool = true
    @StateObject var viewModel = GradientViewModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if sizeClass == .compact {
                    GradientView(viewModel: viewModel)
                        .sheet(isPresented: $isPresented) {
                            MenuView(viewModel: viewModel)
                                .presentationDetents([.height(safeAreaInsets.bottom > 0 ? 60 : 80), .medium])
                                .presentationBackground(.ultraThinMaterial)
                                .presentationCornerRadius(50)
                                .presentationDragIndicator(.visible)
                                .presentationBackgroundInteraction(.enabled)
                                .interactiveDismissDisabled()
                            
                        }
                } else {
                    NavigationSplitView {
                        MenuView(viewModel: viewModel)
                            .navigationTitle("Gradients")
                    } detail: {
                        GradientView(viewModel: viewModel)
                    }
                    .tint(.primary)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    viewModel.generateNewGradient(gradients: gradients, context: context)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
