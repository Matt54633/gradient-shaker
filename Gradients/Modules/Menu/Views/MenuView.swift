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
    @Environment(\.isOnIpad) private var isOnIpad
    @ObservedObject var viewModel: GradientViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                if geometry.size.height < 90 {
                    
                    if !isOnIpad {
                        ShakeDisplayView(viewModel: viewModel)
                            .frame(height:  safeAreaInsets.bottom > 0 ? 60 + safeAreaInsets.bottom : 80)
                    }
                    
                } else {
                    ScrollView {
                        
                        if !isOnIpad {
                            ShakeDisplayView(viewModel: viewModel)
                        }
                        
                        VStack(alignment: isOnIpad ? .leading : .center) {
                            
                            if gradients.filter({ $0.isFavourite }).count > 0 {
                                
                                GradientsFavouritesListView(viewModel: viewModel)
                                
                            }
                        
                            if gradients.filter({ !$0.isFavourite }).count != 0 {
                                GradientsListView(viewModel: viewModel)
                                
                                ClearRecentsView()
                            }
    
                        }
                    }
                    .padding(.top, isOnIpad ? 0 : 28)
                }
            }
        }
    }
}

#Preview {
    MenuView(viewModel: GradientViewModel())
}
