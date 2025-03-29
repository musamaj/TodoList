//
//  AppTheme.swift
//  AppStructure
//
//  Created by Muhammad Azher on 10/25/17.
//  Copyright © 2017 FahidAttique. All rights reserved.
//

import Foundation
import UIKit

class AppTheme {
    
    static let gradient = CAGradientLayer()
    
    // MARK:- Functions
    
    
    class func vendColor(_ r: Float, g: Float, b: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1.0)
    }
    
    class func themeRedColor() -> UIColor {
        return UIColor(red:0.88, green:0.32, blue:0, alpha:1)
    }
    
    class func themeYellowColor() -> UIColor {
        return UIColor(red:255/255, green:158/255, blue:15/255, alpha:1)
    }
    
    class func barItemsTint() -> UIColor {
        return .white
    }
    
    class func lightBlue() -> UIColor {
        return UIColor(red: 57/255, green: 161/255, blue: 248/255, alpha: 1.0)
    }
    
    class func lightYellow() -> UIColor {
        return UIColor(red: 255/255, green: 249/255, blue: 210/255, alpha: 1.0)
    }
    
    class func lightgreen() -> UIColor {
        return UIColor(red: 169/255, green: 219/255, blue: 134/255, alpha: 1.0)
    }
    
    class func green2() -> UIColor {
        return UIColor(red: 112/255, green: 176/255, blue: 39/255, alpha: 1.0)
    }
    
    class func lightBG() -> UIColor {
        return UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1.0)
    }
    
    class func lightGrayBG() -> UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 242/255, alpha: 1.0)
    }

}

extension AppTheme {
    
    class func setNavTint(color: UIColor, view: UIView?, VC: UIViewController? = nil) {
        if let parentView = view {
            parentView.backgroundColor = color
        } else {
            var viewController = UIApplication.topViewController()
            if let vc = VC {
                viewController = vc
            }
            viewController?.navigationController?.navigationBar.barTintColor = color
            viewController?.navigationController?.navigationBar.tintColor = color
        }
    }
    
    class func addGradient(view: UIView?, colors: [UIColor]) {
        gradient.colors = [colors[0].cgColor, colors[1].cgColor]
        
        if let parentView = view {
            var bounds = parentView.bounds
            bounds.size.width = UIApplication.topViewController()?.view.frame.width ?? parentView.bounds.size.width
            gradient.frame = bounds
            gradient.name  = App.placeholders.bgGradient
            parentView.layer.insertSublayer(gradient, at: 0)
        } else {
            if var navFrame = UIApplication.topViewController()?.navigationController?.navigationBar.bounds {
                navFrame.size.height += UIApplication.shared.statusBarFrame.size.height
                gradient.frame  = navFrame
                UIApplication.topViewController()?.navigationController?.navigationBar.barTintColor = .clear
                UIApplication.topViewController()?.navigationController?.navigationBar.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
            }
        }
    }
    
    class func updateGradient(view: UIView, gradients: [UIColor], layer: CAGradientLayer) {
        layer.colors = [gradients[0].cgColor, gradients[1].cgColor]
        
        var bounds = view.bounds
        bounds.size.width = view.frame.width
        layer.frame = bounds
        layer.name  = App.placeholders.bgGradient
    }
    
    class func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    class func setNavBartheme(view: UIView? = nil, VC: UIViewController? = nil) {
        
        if let index = appUtility.appTheme {
            if let colortheme = App.arrThemes[index] as? UIColor {
                self.setNavTint(color: colortheme, view: view, VC: VC)
            } else if let gradientTheme = App.arrThemes[index] as? [UIColor] {
                if let parentView = view {
                    parentView.backgroundColor = gradientTheme[0].lighter(by: 20)
                } else {
                    self.setNavTint(color: gradientTheme[0].lighter(by: 20) ?? gradientTheme[0], view: view, VC: VC)
                }
            } else if let imageStr = App.arrThemes[index] as? String {
                let backgroundColor = App.imgColors[imageStr] ?? UIColor.darkGray
                if let parentView = view {
                    parentView.backgroundColor = backgroundColor
                } else {
                    self.setNavTint(color: backgroundColor, view: view, VC: VC)
                }
            }
        } else {
            self.setNavTint(color: UIColor.darkGray, view: view, VC: VC)
        }
    }
    
    class func setTheme(view: UIView) {
        
        if let index = appUtility.appTheme {
            if let colortheme = App.arrThemes[index] as? UIColor {
                view.backgroundColor = colortheme.lighter()
                
            } else if let gradientTheme = App.arrThemes[index] as? [UIColor] {
                self.addGradient(view: view, colors: gradientTheme)
                
            } else if let imageStr = App.arrThemes[index] as? String {
                let imgBackground = UIImageView.init(image: UIImage.init(named: imageStr))
                imgBackground.frame = view.frame
                view.insertSubview(imgBackground, at: 0)
            }
        } else {
            view.backgroundColor = UIColor.darkGray.lighter()
        }
    }
    
}


extension UIColor {
    
    func lighter(by percentage: CGFloat = 20.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
