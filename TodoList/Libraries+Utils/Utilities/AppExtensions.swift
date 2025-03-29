//
//  AppExtensions.swift
//  ListFixx
//
//  Created by Usama Jamil on 16/01/2019.
//  Copyright © 2019 Square63. All rights reserved.
//

import Foundation
import SVProgressHUD


extension UIViewController: AppRouter {
}

extension UIView {
    
    func setRounded(_ width: CGFloat = 0.0, _ color: UIColor = .clear) {
        self.layer.cornerRadius = (self.frame.width / 2).rounded()
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
    }
    
    func setRounded(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setRounded(cornerRadius: CGFloat, width: CGFloat, color: UIColor) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
    }
}

extension Utility {
    
    class func returnHeight(width: Int, height: Int, myView: UIView)-> CGFloat {
        let ratio = CGFloat(width) / CGFloat(height)
        let newHeight = (myView.frame.width-20) / ratio
        return newHeight
    }
}


extension String {
    
    func containsNumbers() -> Bool {
        
        // check if there's a range for a number
        let range = self.rangeOfCharacter(from: .decimalDigits)
        
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
        
    }
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacter(from: .whitespaces)
        
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}



extension String
{
    func hashtags() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        {
            let string = self as NSString
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
            }
        }
        
        return []
    }
    
    func mentions() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "@[a-z0-9]+", options: .caseInsensitive)
        {
            let string = self as NSString
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "@", with: "").lowercased()
            }
        }
        
        return []
    }
}

extension NSLayoutConstraint {
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String, color: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        self.attributedText = attribute
    }
    
    func halfTextBold (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.avenirMediumFontOfSize(16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold) , range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        self.attributedText = attribute
    }
    
    func halfTextFontChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13) , range: range)
        self.attributedText = attribute
    }
}
