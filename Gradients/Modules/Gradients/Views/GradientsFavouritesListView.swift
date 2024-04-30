//
//  GradientsFavouritesListView.swift
//  Gradients
//
//  Created by Matt Sullivan on 29/04/2024.
//

import SwiftUI
import SwiftData

struct GradientsFavouritesListView: View {
    @Query private var gradients: [GradientModel]
    @Environment(\.modelContext) var context
    @Environment(\.isOnMac) private var isOnMac
    @Environment(\.isOnIpad) private var isOnIpad
    @ObservedObject var viewModel: GradientViewModel
    @State private var isExporting = false
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        HStack {
            
            Image(systemName: "star")
            
            Text("Favourites")
            
        }
        .font(.headline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .padding([.horizontal, .top])
        .foregroundStyle(isOnIpad ? .primary : Color(.white))
        
        
        if isOnIpad {
            Divider()
                .padding(.horizontal)
        }
        
        
        LazyVGrid(columns: columns, spacing: 5) {
            
            ForEach(gradients.reversed().filter { $0.isFavourite }, id: \.self) { gradient in
                
                let startUIColor = UIColor(ciColor: CIColor(string: gradient.startColour))
                let endUIColor = UIColor(ciColor: CIColor(string: gradient.endColour))
                
                Button {
                    viewModel.selectGradient(gradient: gradient, context: context)
                } label: {
                    
                    GradientListItemView(startColour: Color(startUIColor), endColour: Color(endUIColor), angle: gradient.angle, viewModel: viewModel)
                        .contextMenu {
                            
                            Button(action: {
                                viewModel.selectGradient(gradient: gradient, context: context)
                            }) {
                                Text("Set Current")
                                Image(systemName: "viewfinder")
                            }
                            
                            Button(action: {
                                gradient.isFavourite.toggle()
                            }) {
                                Text(gradient.isFavourite ? "Remove from Favourites" : "Add to Favourites")
                                Image(systemName: gradient.isFavourite ? "star.slash" : "star")
                            }
                            
                            
                            
                            Button(action: {
                                viewModel.capturePreviousSnapshot(saveToPhotos: isOnMac ? false: true, gradient: gradient)
                                
                                if isOnMac {
                                    isExporting = true
                                }
                            }) {
                                Text("Save to Photos")
                                Image(systemName: "arrow.down.circle")
                            }
                            
                            Button(action: {
                                viewModel.exportAsCss(gradient: gradient)
                            }) {
                                Text("Copy CSS")
                                Image(systemName: "doc.on.doc")
                            }
                            
                            Button(action: {
                                viewModel.exportAsTailwind(gradient: gradient)
                            }) {
                                Text("Copy TailwindCSS")
                                Image("tailwind")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.primary)
                            }
                            
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                viewModel.deleteGradient(gradient: gradient, context: context)
                            }
                        }
                    
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        .fileExporter(isPresented: $isExporting, document: ImageDocument(image: viewModel.snapshot), contentType: .png, defaultFilename: "snapshot") { result in
            switch result {
            case .success(_):
                viewModel.animate($viewModel.isSaved)
            case .failure(_):
                viewModel.animate($viewModel.isErrored)
            }
        }
    }
}

#Preview {
    GradientsFavouritesListView(viewModel: GradientViewModel())
}
