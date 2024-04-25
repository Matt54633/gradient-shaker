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

    var body: some View {
        GeometryReader { geometry in
            VStack {
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
