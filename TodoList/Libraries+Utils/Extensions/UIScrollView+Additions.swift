//
//  UIScrollView+Additions.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 15/02/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
 
    func scrollToTop() {
        setContentOffset(CGPoint.zero, animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: true)
    }
}
