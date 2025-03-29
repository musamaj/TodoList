//
//  NSObjectProtocol+Additions.swift
//  AppStructure
//
//  Created by Muhammad Azher on 18/01/2018.
//  Copyright © 2018 FahidAttique. All rights reserved.
//

import Foundation

extension NSObjectProtocol {

    static var identifier: String { return String(describing: self) }
}
