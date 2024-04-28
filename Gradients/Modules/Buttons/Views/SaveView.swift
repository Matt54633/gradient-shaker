//
//  SaveView.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import SwiftUI

struct SaveView: View {
    @Environment(\.isOnMac) var isOnMac
    @ObservedObject var viewModel: GradientViewModel
    @State private var isExporting = false
    
    var body: some View {
        Button {
            viewModel.captureSnapshot(saveToPhotos: isOnMac ? false : true)
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if isOnMac {
                isExporting = true
            }
        } label: {
            
            Image(systemName: "arrow.down.circle")
                .font(.title)
                .foregroundStyle(.white)
            
        }
        .fileExporter(isPresented: $isExporting, document: ImageDocument(image: viewModel.snapshot), contentType: .png, defaultFilename: "snapshot") { result in
            switch result {
            case .success(_):
                viewModel.animate($viewModel.isSaved)
            case .failure(_):
                viewModel.animate($viewModel.isErrored)
            }
        }
        .padding(7.5)
        .background(Circle().fill(.ultraThinMaterial))
        
    }
}

#Preview {
    SaveView(viewModel: GradientViewModel())
}
