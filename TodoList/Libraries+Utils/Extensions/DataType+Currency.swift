//
//  DataType+Currency.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 19/02/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation


extension Double {
    
    var toDollars: String {
        get {
            return "$" + String(format: "%.2f", self)
        }
    }
}



extension Float {
    
    var roundedIfNeeded: Float {
        get {
            return (self == 0.0) ? 0.1 : self
        }
    }
}



extension String {
    
    var toDollars: String {
        get {
            return "$" + String(format: "%.2f", self.doubleValue)
        }
    }
    
    var doubleValue: Double {
        get {
            return (self as NSString).doubleValue
        }
    }
    
    var floatValue: Float {
        get {
            return (self as NSString).floatValue
        }
    }

    var integerValue: Int {
        get {
            return (self as NSString).integerValue
        }
    }

    var roundedIfNeeded: Float {
        get {
            return floatValue.roundedIfNeeded
        }
    }

    
}
