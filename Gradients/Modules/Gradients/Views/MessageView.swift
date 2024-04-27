//
//  MessageView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI

struct MessageView: View {
    let message: String
    let image: String
    let systemImage: Bool
    
    var body: some View {
        HStack {
            
            if systemImage {
                Image(systemName: image)
                    .font(.title2)
            } else {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            
            Text(message)
                .fontDesign(.rounded)
            
        }
        .fontWeight(.semibold)
        .foregroundStyle(.white)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
        .background(Capsule().fill(.ultraThinMaterial))
        
    }
}

#Preview {
    MessageView(message: "Saved", image: "checkmark.circle", systemImage: true)
}
