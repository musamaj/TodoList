//
//  AppConfigs.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 16/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation


/// Application mode
///
/// - Example:
///     - can be used for multiple purposes i.e: testing or for production release


enum AppMode: Int {
    case test = 0, production
}




/// Application mode variable
///
/// - Usage:
///     - Change the app mode from this variable's value



var appMode: AppMode {
    return .test
}






