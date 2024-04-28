//
//  GradientViewModel.swift
//  Gradients
//
//  Created by Matt Sullivan on 22/04/2024.
//

import Foundation
import SwiftUI
import SwiftData
import SWTools

class GradientViewModel: NSObject, ObservableObject {
    
    @Published var startColour: Color = .cyan
    @Published var endColour: Color = .blue
    @Published var angle: Double = 0
    @Published var snapshot: UIImage? = nil
    @Published var isSaved: Bool = false
    @Published var isCopied: Bool = false
    @Published var isErrored: Bool = false
    @Published var lastShakeTime = Date.distantPast
    
    func animate(_ value: Binding<Bool>) {
            withAnimation(.easeInOut(duration: 0.25)) {
                value.wrappedValue = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    value.wrappedValue = false
                }
            }
        }
    
    func shake(_ value: Binding<CGFloat>) {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true)) {
                value.wrappedValue = 10
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    value.wrappedValue = 0
                }
            }
        }
    
    func changeColour()  {
        let red1 = Double.random(in: 0...1)
        let green1 = Double.random(in: 0...1)
        let blue1 = Double.random(in: 0...1)
        startColour = Color(red: red1, green: green1, blue: blue1)
        
        let red2 = Double.random(in: 0...1)
        let green2 = Double.random(in: 0...1)
        let blue2 = Double.random(in: 0...1)
        endColour = Color(red: red2, green: green2, blue: blue2)
        
        angle = Double.random(in: 0...360)
    }
    
    func captureSnapshot(saveToPhotos: Bool) {
        let gradient = LinearGradient(gradient: Gradient(colors: [startColour, endColour]), startPoint: .init(x: cos(angle), y: sin(angle)), endPoint: .init(x: cos(angle + .pi), y: sin(angle + .pi)))
        let controller = UIHostingController(rootView: Rectangle().fill(gradient).edgesIgnoringSafeArea(.all))
        controller.view.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        let view = controller.view
        let scale = UIScreen.main.scale * 4.0
        
        UIGraphicsBeginImageContextWithOptions(controller.view.bounds.size, false, scale)
        view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        snapshot = image
        
        if saveToPhotos {
            saveImageToPhotoLibrary()
        }
        
    }
    
    func capturePreviousSnapshot(saveToPhotos: Bool, gradient: GradientModel) {
        let startUIColor = UIColor(ciColor: CIColor(string: gradient.startColour))
        let endUIColor = UIColor(ciColor: CIColor(string: gradient.endColour))
        
        let gradient = LinearGradient(gradient: Gradient(colors: [Color(startUIColor), Color(endUIColor)]), startPoint: .init(x: cos(gradient.angle), y: sin(gradient.angle)), endPoint: .init(x: cos(gradient.angle + .pi), y: sin(gradient.angle + .pi)))
        let controller = UIHostingController(rootView: Rectangle().fill(gradient).edgesIgnoringSafeArea(.all))
        controller.view.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        let view = controller.view
        let scale = UIScreen.main.scale * 4.0
        
        UIGraphicsBeginImageContextWithOptions(controller.view.bounds.size, false, scale)
        view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        snapshot = image
        
        if saveToPhotos {
            saveImageToPhotoLibrary()
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    
    }
    
    func saveImageToPhotoLibrary() {
        guard let image = snapshot else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            animate(Binding(get: { self.isSaved }, set: { self.isSaved = $0 }))
        } else {
            animate(Binding(get: { self.isErrored }, set: { self.isErrored = $0 }))
        }
    }
    
    func generateNewGradient(gradients: [GradientModel], context: ModelContext) {
        
        self.changeColour()

        let now = Date()
        guard now.timeIntervalSince(lastShakeTime) > 0.5 else { return }
        lastShakeTime = now
        
        let startColourString = CIColor(color: UIColor(self.startColour)).stringRepresentation
        let endColourString = CIColor(color: UIColor(self.endColour)).stringRepresentation
        
        if !gradients.contains(where: { $0.startColour == startColourString && $0.endColour == endColourString && $0.angle == self.angle }) {
            if gradients.count >= 30 {
                context.delete(gradients.first!)
            }
            
            context.insert(GradientModel(startColour: startColourString, endColour: endColourString, angle: self.angle))
            
        }
        
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func selectGradient(gradient: GradientModel, context: ModelContext) {
        let startUIColor = UIColor(ciColor: CIColor(string: gradient.startColour))
        let endUIColor = UIColor(ciColor: CIColor(string: gradient.endColour))
        
        self.startColour = Color(startUIColor)
        self.endColour = Color(endUIColor)
        self.angle = gradient.angle
        
        context.delete(gradient)
        context.insert(GradientModel(startColour: gradient.startColour, endColour: gradient.endColour, angle: gradient.angle))
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func deleteGradient(gradient: GradientModel, context: ModelContext) {
        context.delete(gradient)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func exportAsCss(gradient: GradientModel) {
        
        let startColor = UIColor(ciColor: CIColor(string: gradient.startColour)).rgba
        let endColor = UIColor(ciColor: CIColor(string: gradient.endColour)).rgba
        let cssGradient = "linear-gradient(\(gradient.angle)deg, rgba(\(startColor.red * 255), \(startColor.green * 255), \(startColor.blue * 255), \(startColor.alpha)), rgba(\(endColor.red * 255), \(endColor.green * 255), \(endColor.blue * 255), \(endColor.alpha)))"
        
        UIPasteboard.general.string = cssGradient
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.25)) {
            isCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.25)) {
                self.isCopied = false
            }
        }
    }
    
    func exportAsTailwind(gradient: GradientModel) {
        let startColor = UIColor(ciColor: CIColor(string: gradient.startColour))
        let endColor = UIColor(ciColor: CIColor(string: gradient.endColour))
        let startColorRGB = startColor.rgba
        let endColorRGB = endColor.rgba
        let directionClass = angleToDirectionClass(angle: gradient.angle)
        let tailwindGradient = "\(directionClass) from-[rgb(\(startColorRGB.red * 255),\(startColorRGB.green * 255),\(startColorRGB.blue * 255))] to-[rgb(\(endColorRGB.red * 255),\(endColorRGB.green * 255),\(endColorRGB.blue * 255))]"
        
        UIPasteboard.general.string = tailwindGradient
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.25)) {
            isCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.25)) {
                self.isCopied = false
            }
        }
    }
    
    func angleToDirectionClass(angle: Double) -> String {
        switch angle {
        case 0..<45:
            return "bg-gradient-to-t"
        case 45..<90:
            return "bg-gradient-to-tr"
        case 90..<135:
            return "bg-gradient-to-r"
        case 135..<180:
            return "bg-gradient-to-br"
        case 180..<225:
            return "bg-gradient-to-b"
        case 225..<270:
            return "bg-gradient-to-bl"
        case 270..<315:
            return "bg-gradient-to-l"
        default:
            return "bg-gradient-to-tl"
        }
    }
    
}
