//
//  UIResponder+Additions.swift
//  LoGx
//
//  Created by Muhammad Azher on 24/03/2018.
//  Copyright © 2018 Logx. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {

    func chainedResponderOf<T: Any>(type responderClassType: T) -> UIResponder? {

        guard let classType = responderClassType as? AnyClass else { return nil }
        
        var responder: UIResponder? = self.next

        while responder != nil {
            
            if responder!.isKind(of: classType) {
                return responder!
            }
            responder = responder!.next
        }
        
        return nil
    }
}
