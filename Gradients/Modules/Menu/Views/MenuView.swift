//
//  MenuView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData
import UIKit
import SWTools

struct MenuView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                if geometry.size.height < 90 {
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        
                        ShakeDisplayView()
                            .frame(height:  safeAreaInsets.bottom > 0 ? 60 + safeAreaInsets.bottom : 80)
                        
                    }
                    
                } else {
                    ScrollView {
                        
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            ShakeDisplayView()
                        }
                        
                        GradientsListView(viewModel: viewModel)
                        
                        if !gradients.isEmpty {
                            DeleteAllView()
                        }
                        
                    }
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .phone ? 28 : 0)
                }
            }
        }
    }
}

#Preview {
    MenuView(viewModel: GradientViewModel())
}
