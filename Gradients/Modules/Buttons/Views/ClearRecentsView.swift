//
//  ClearRecentsView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData

struct ClearRecentsView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @State private var showingConfirmation = false
    
    var body: some View {
        Button {
            showingConfirmation = true
        } label: {
            Text("Clear Recents")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
        }
        .tint(.red)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .buttonBorderShape(.roundedRectangle(radius: 15))
        .buttonStyle(.borderedProminent)
        .padding([.horizontal, .bottom])
        .alert("Clear Recents", isPresented: $showingConfirmation, actions: {
            Button("Clear", role: .destructive) {
                for gradient in gradients {
                    if !gradient.isFavourite {
                        context.delete(gradient)
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Are you sure you want to clear all recents?")
        })
    }
}

#Preview {
    ClearRecentsView()
}
