////
////  SafeAreaDetector.swift
////  Gradients
////
////  Created by Matt Sullivan on 23/04/2024.
////
//
//import Foundation
//import SwiftUI
//
//extension UITabBarController {
//    var height: CGFloat {
//        return self.tabBar.frame.size.height
//    }
//    
//    var width: CGFloat {
//        return self.tabBar.frame.size.width
//    }
//}
//
//
//extension UIApplication {
//    var keyWindow: UIWindow? {
//        connectedScenes
//            .compactMap {
//                $0 as? UIWindowScene
//            }
//            .flatMap {
//                $0.windows
//            }
//            .first {
//                $0.isKeyWindow
//            }
//    }
//    
//}
//
//private struct SafeAreaInsetsKey: EnvironmentKey {
//    static var defaultValue: EdgeInsets {
//        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
//    }
//}
//
//
//private extension UIEdgeInsets {
//    var swiftUiInsets: EdgeInsets {
//        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
//    }
//}
//
//
//extension EnvironmentValues {
//    var safeAreaInsets: EdgeInsets {
//        self[SafeAreaInsetsKey.self]
//    }
//}
