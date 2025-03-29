//
//  Persistence.swift
//  Listfixx
//
//  Created by Usama Jamil on 10/10/2018.
//  Copyright © 2018 Usama Jamil. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class Persistence: NSObject
{
    static let shared: Persistence = {
        let instance = Persistence()
        return instance
    }()
    
    var accessToken: String? {
        set {
            Defaults[.accessToken] = newValue
        }
        get {
            if Defaults[.accessToken] != nil {
                return Defaults[.accessToken]!
            } else {
                return nil
            }
        }
    }
    
    var deviceID: String? {
        set {
            Defaults[.deviceID] = newValue
        }
        get {
            if Defaults[.deviceID] != nil {
                return Defaults[.deviceID]!
            } else {
                return nil
            }
        }
    }
    
    
    // Will be used to fetch latest updates from change stream endpoint
    
    
    var refreshToken: String? {
        set {
            Defaults[.refreshToken] = newValue
        }
        get {
            if Defaults[.refreshToken] != nil {
                return Defaults[.refreshToken]!
            } else {
                return nil
            }
        }
    }
    
    
    var isAppAlreadyLaunchedForFirstTime: Bool {
        set {
            Defaults[.isAppAlreadyLaunchedForFirstTime] = newValue
        }
        get {
            if Defaults[.isAppAlreadyLaunchedForFirstTime] != nil {
                let isAppAlreadyLaunchedForFirstTime = Defaults[.isAppAlreadyLaunchedForFirstTime]
                if isAppAlreadyLaunchedForFirstTime! {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    var isUserAlreadyLoggedIn: Bool {
        set {
            Defaults[.isUserAlreadyLoggedIn] = newValue
        }
        get {
            if Defaults[.isUserAlreadyLoggedIn] != nil {
                let isUserAlreadyLoggedIn = Defaults[.isUserAlreadyLoggedIn]
                if isUserAlreadyLoggedIn! {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    var isSignUP: Bool {
        set {
            Defaults[.isSignedUp] = newValue
        }
        get {
            if Defaults[.isSignedUp] != nil {
                let isSignUP = Defaults[.isSignedUp]
                if isSignUP! {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    var isSocialLoggedIn: Bool {
        set {
            Defaults[.isSocailLoggedIn] = newValue
        }
        get {
            if Defaults[.isSocailLoggedIn] != nil {
                let isUserAlreadyLoggedIn = Defaults[.isSocailLoggedIn]
                if isUserAlreadyLoggedIn! {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    var currentUserID: String {
        set {
            Defaults[.currentUserID] = newValue
        }
        get {
            if Defaults[.currentUserID] != nil {
                return Defaults[.currentUserID]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserUrlHash: String {
        set {
            Defaults[.currentUserUrlHash] = newValue
        }
        get {
            if Defaults[.currentUserUrlHash] != nil {
                return Defaults[.currentUserUrlHash]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserFirstName: String {
        set {
            Defaults[.currentUserFirstName] = newValue
        }
        get {
            if Defaults[.currentUserFirstName] != nil {
                return Defaults[.currentUserFirstName]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserLastName: String {
        set {
            Defaults[.currentUserLastName] = newValue
        }
        get {
            if Defaults[.currentUserLastName] != nil {
                return Defaults[.currentUserLastName]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserEmail: String {
        set {
            Defaults[.currentUserEmail] = newValue
        }
        get {
            if Defaults[.currentUserEmail] != nil {
                return Defaults[.currentUserEmail]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserUsername: String {
        set {
            Defaults[.currentUserUsername] = newValue
        }
        get {
            if Defaults[.currentUserUsername] != nil {
                return Defaults[.currentUserUsername]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserLocation: String {
        set {
            Defaults[.currentUserLocation] = newValue
        }
        get {
            if Defaults[.currentUserLocation] != nil {
                return Defaults[.currentUserLocation]!
            } else {
                return ""
            }
        }
    }
    
    var currentUserBio: String {
        set {
            Defaults[.currentUserBio] = newValue
        }
        get {
            if Defaults[.currentUserBio] != nil {
                return Defaults[.currentUserBio]!
            } else {
                return ""
            }
        }
    }
    
    var lastLoginEmail: String {
        set {
            Defaults[.lastUserEmail] = newValue
        }
        get {
            if Defaults[.lastUserEmail] != nil {
                return Defaults[.lastUserEmail]!
            } else {
                return ""
            }
        }
    }
    
    var lastLoginPassword: String {
        set {
            Defaults[.lastUserPassword] = newValue
        }
        get {
            if Defaults[.lastUserPassword] != nil {
                return Defaults[.lastUserPassword]!
            } else {
                return ""
            }
        }
    }
    
    var currentIsVerified: Bool {
        set {
            Defaults[.currentIsVerified] = newValue
        }
        get {
            if Defaults[.currentIsVerified] != nil {
                return Defaults[.currentIsVerified]!
            } else {
                return false
            }
        }
    }
    
    func removeAllPersitedData()
    {
        Defaults.removeAll()
    }
}







