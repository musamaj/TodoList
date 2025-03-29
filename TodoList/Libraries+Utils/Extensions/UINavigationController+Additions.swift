//
//  UINavigationController+Additions.swift
//  ListFixx
//
//  Created by Muhammad Azher on 30/08/2018.
//  Copyright © 2018 Square63. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationController {
    
    
    func setNavBarWithBottomLine(setHidden hidden : Bool) {
        
        self.navigationBar.setValue(hidden, forKey: "hidesShadow")
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .blue
    }

}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}


extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
