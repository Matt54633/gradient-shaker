//
//  MenuView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.horizontalSizeClass) var sizeClass
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                if geometry.size.height < 90 {
                    
                    if sizeClass != .compact {
                        
                        ShakeDisplayView()
                            .frame(height:  safeAreaInsets.bottom > 0 ? 60 + safeAreaInsets.bottom : 80)
                        
                    }
                    
                } else {
                    ScrollView {
            
                        if sizeClass != .compact {
                            ShakeDisplayView()
                        }
                        
                        GradientsListView(viewModel: viewModel)
                        
                        if !gradients.isEmpty {
                            DeleteAllView()
                        }
                        
                    }
                    .padding(.top, sizeClass != .compact ? 28 : 0)
                }
            }
        }
    }
}

#Preview {
    MenuView(viewModel: GradientViewModel())
}
