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
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                if geometry.size.height < 90 {
                    ShakeDisplayView()
                        .frame(height:  safeAreaInsets.bottom > 0 ? 60 + safeAreaInsets.bottom : 80)
                } else {
                    
                    ScrollView {
                        ShakeDisplayView()
                        
                        GradientsListView(viewModel: viewModel)
                            
                        
                        if !gradients.isEmpty {
                            DeleteAllView()
                        }
                        
                    }
                    .padding(.top, 28)
                }
                
            }
            
        }
    }
}

#Preview {
    MenuView(viewModel: GradientViewModel())
}
