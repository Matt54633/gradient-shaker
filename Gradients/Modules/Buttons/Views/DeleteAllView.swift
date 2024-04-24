//
//  DeleteAllView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI
import SwiftData

struct DeleteAllView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @State private var showingConfirmation = false
    
    var body: some View {
        Button {
            showingConfirmation = true
        } label: {
            
            Text("Delete All")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            
        }
        .tint(.red)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .buttonBorderShape(.roundedRectangle(radius: 15))
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
        .alert("Delete All Gradients", isPresented: $showingConfirmation, actions: {
            Button("Delete", role: .destructive) {
                for gradient in gradients {
                    context.delete(gradient)
                }
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Are you sure you want to delete all gradients?")
        })
    }
}

#Preview {
    DeleteAllView()
}
