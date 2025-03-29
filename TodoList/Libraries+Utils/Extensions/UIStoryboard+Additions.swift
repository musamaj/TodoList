//
//  UIStoryboard+Additions.swift
//  LanguageParrot
//
//  Created by Muhammad Azher on 01/08/2016.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit

extension UIStoryboard {

    
    // MARK: Class Properties
    
    class var main: UIStoryboard {
        return storyboard(loadWithName: "Main")
    }
    class var groceries: UIStoryboard {
        return storyboard(loadWithName: "Groceries")
    }
    class var recipes: UIStoryboard {
        return storyboard(loadWithName: "Recipes")
    }
    class var tabBar: UIStoryboard {
        return storyboard(loadWithName: "Tabbar")
    }
    class var explore: UIStoryboard {
        return storyboard(loadWithName: "Explore")
    }

    
    
    // MARK: Functions
    
    class func storyboard(loadWithName name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
}
