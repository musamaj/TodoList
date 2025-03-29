//
//  Animations.swift
//  TodoList
//
//  Created by Usama Jamil on 18/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


class Animations: NSObject {

    class func toggleMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat, toggle: Bool, subViewIndex:Int = 0) {
        
        if toggle {
            self.showMenu(menuView: menuView, controller: controller, tabBarHeight: tabBarHeight, subViewIndex: subViewIndex)
        } else {
            self.hideMenu(menuView: menuView, controller: controller, tabBarHeight: tabBarHeight)
        }
    }
    
    class func showMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat, subViewIndex:Int = 0)
    {
        if !menuView.isDescendant(of: controller.view) {
            if subViewIndex == 0 {
                controller.view.addSubview(menuView)
            } else if subViewIndex == 10 {
                controller.view.insertSubview(menuView, aboveSubview: controller.view)
            } else {
                controller.view.insertSubview(menuView, at: subViewIndex)
            }
        }
        
        menuView.bringSubviewToFront(controller.view)
        
        let height = menuView.frame.height
        menuView.frame.size.width = controller.view.frame.size.width
        menuView.frame.origin.y = controller.view.frame.height
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .transitionCrossDissolve, animations: {
            
            menuView.frame.origin.y -= height+tabBarHeight
            controller.view.layoutIfNeeded()
        }, completion: { (done) in
            
        })
    }
    
    class func hideMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat) {
        if controller.view.subviews.contains(menuView) {
            let height = menuView.frame.height
            menuView.sendSubviewToBack(controller.view)
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .transitionCrossDissolve, animations: {
                
                //menuView.frame.size.height = height
                menuView.frame.origin.y += height + tabBarHeight
                controller.view.layoutIfNeeded()
            }, completion: { (done) in
                menuView.removeFromSuperview()
            })
            
        }
    }

}
