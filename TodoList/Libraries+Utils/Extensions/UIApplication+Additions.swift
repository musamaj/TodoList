//
//  UIApplication+Additions.swift
//  TodoList
//
//  Created by Usama Jamil on 07/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

//extension UIApplication {
//    var statusBarUIView: UIView? {
//        if #available(iOS 13.0, *) {
//            let tag = 38482
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            
//            if let statusBar = keyWindow?.viewWithTag(tag) {
//                return statusBar
//            } else {
//                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
//                let statusBarView = UIView(frame: statusBarFrame)
//                statusBarView.tag = tag
//                keyWindow?.addSubview(statusBarView)
//                return statusBarView
//            }
//        } else if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        } else {
//            return nil
//        }
//    }
//}
