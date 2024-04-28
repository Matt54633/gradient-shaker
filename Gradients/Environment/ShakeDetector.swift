////
////  ShakeDetector.swift
////  Gradients
////
////  Created by Matt Sullivan on 22/04/2024.
////
//
//import Foundation
//import SwiftUI
//import CoreMotion
//
//// ShakeDetector
//class ShakeDetector: ObservableObject {
//    private let motionManager = CMMotionManager()
//    private let queue = OperationQueue()
//    private let threshold: Double = 2.0
//    @Published var didShake: Bool = false
//    private var cooldown: Bool = false
//    private var shakeInProgress: Bool = false
//    
//    func startUpdates() {
//        guard motionManager.isDeviceMotionAvailable else { return }
//        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (motion, error) in
//            guard let self = self, let motion = motion else { return }
//            if !self.cooldown && !self.shakeInProgress && (abs(motion.userAcceleration.x) > self.threshold ||
//                                                           abs(motion.userAcceleration.y) > self.threshold ||
//                                                           abs(motion.userAcceleration.z) > self.threshold) {
//                DispatchQueue.main.async {
//                    self.didShake = true
//                    self.shakeInProgress = true
//                    self.cooldown = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.cooldown = false
//                        self.didShake = false
//                        self.shakeInProgress = false
//                    }
//                }
//            }
//        }
//    }
//    
//    func stopUpdates() {
//        motionManager.stopDeviceMotionUpdates()
//    }
//}
//
//// ShakeViewModifier
//struct ShakeViewModifier: ViewModifier {
//    @StateObject private var shakeDetector = ShakeDetector()
//    let action: () -> Void
//    
//    func body(content: Content) -> some View {
//        content
//            .onReceive(shakeDetector.$didShake) { didShake in
//                if didShake {
//                    action()
//                    shakeDetector.didShake = false
//                }
//            }
//            .onAppear {
//                shakeDetector.startUpdates()
//            }
//            .onDisappear {
//                shakeDetector.stopUpdates()
//            }
//    }
//}
//
//// View extension
//extension View {
//    func onShake(perform action: @escaping () -> Void) -> some View {
//        self.modifier(ShakeViewModifier(action: action))
//    }
//}
