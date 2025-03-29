//
//  FacebookManager.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 11/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import Foundation
//import FacebookCore
//import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookManager {
    
    //static let sharedInstance = FacebookManager()
    
    fileprivate let cancelError = "You have cancelled Login."
    
    fileprivate func tryAuthenticate(fromViewController viewController:UIViewController, success: @escaping ((_ facebookToken:String) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        FacebookManager.logout()
        if let currentAccessToken = FBSDKAccessToken.current() {
            success(currentAccessToken.tokenString)
            return
        }
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = .browser
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: viewController) { (result, error) in
            
            if let facebookError = error { //If any error returned from Facebook
                failure(facebookError as NSError?)
                return
            }
            
            if (result?.isCancelled)! { //If user has cancelled the login
                let canceledError = NSError.init(domain: self.cancelError, code: 0, userInfo: [:])
                failure(canceledError)
                return
            }
            
            
            success((result?.token.tokenString)!)
        }
        
    }
    
    fileprivate func tryAuthenticate2(fromViewController viewController:UIViewController, success: @escaping ((_ facebookToken:String) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        FacebookManager.logout()
        if let currentAccessToken = FBSDKAccessToken.current() {
            success(currentAccessToken.tokenString)
            return
        }
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = .browser
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withPublishPermissions: ["publish_actions"], from: viewController) { (result, error) in
            
            if let facebookError = error { //If any error returned from Facebook
                failure(facebookError as NSError?)
                return
            }
            
            if (result?.isCancelled)! { //If user has cancelled the login
                let canceledError = NSError.init(domain: self.cancelError, code: 0, userInfo: [:])
                failure(canceledError)
                return
            }
            
            
            success((result?.token.tokenString)!)
        }
        
    }
    
    fileprivate func fetchLoggedUserInfo(successBlock success: @escaping ((_ facebookUserInfo:[String : AnyObject]) -> Void), failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        _ = meRequest?.start { (connection, graphObject, error) in
            
            if error != nil {
                failure(error as NSError?)
                return
            }
            
            success(graphObject as! [String: AnyObject])
        }
        
    }
    // This method will automatically handle login and it's permissions
    
    func loginWithFacebook(_ viewController : UIViewController,success: @escaping ((_ facebookUserInfo:[String : AnyObject], _ token: String) -> Void),failureBlock failure: @escaping ((_ error: NSError?) -> Void)) {
        
        self.tryAuthenticate(fromViewController: viewController, success: { [weak self](accessToken) in
            guard let weakSelf = self else {return}
            weakSelf.fetchLoggedUserInfo(successBlock: { (userInfo) in
                
                success(userInfo,accessToken)
                
            }, failureBlock: { (error1) in
                
                failure(error1)
                
            })
            
        }) { (error) in
            failure(error)
        }
    }
    
    class func logout() {
        FBSDKLoginManager().logOut()
    }
    
//    func requestPermissionAndPost() {
//        FBSession.activeSession.requestNewPublishPermissions(["publish_actions", "publish_checkins"], defaultAudience: FBSessionDefaultAudienceEveryone, completionHandler: { session, error in
//            if error == nil {
//                // Now have the permission
//                self.postOpenGraphAction()
//            } else {
//                // Facebook SDK * error handling *
//                // if the operation is not user cancelled
//                if error?.fberrorCategory != FBErrorCategoryUserCancelled {
//                    self.presentAlert(forError: error)
//                }
//            }
//        })
//    }
//    
//    func postOpenGraphAction() {
//        let newConnection = FBRequestConnection()
//        let handler = { connection, result, error in
//            // output the results of the request
//            try? self.requestCompleted(connection, forFbID: "me", result: result)
//            } as? FBRequestHandler
//        
//        let img: UIImage? = imageView.image
//        let message = "Your Message"
//        var request: FBRequest? = nil
//        if let anImg = .uiImageJPEGRepresentation() {
//            request = FBRequest(session: FBSession.activeSession, graphPath: "me/photos", parameters: [
//                "source" : anImg,
//                "message" : message,
//                "privacy" : "{'value':'EVERYONE'}"
//                ], httpMethod: "POST")
//        }
//        
//        
//        newConnection.add(request, completionHandler: handler)
//        requestConnection.cancel()
//        requestConnection = newConnection
//        newConnection.start()
//    }
//    
//    // FBSample logic
//    // Report any results.  Invoked once for each request we make.
//    func requestCompleted(_ connection: FBRequestConnection?, forFbID: fbID , result: Any?) throws {
//        print("request completed")
//        
//        // not the completion we were looking for...
//        if requestConnection && connection != requestConnection {
//            print("    not the completion we are looking for")
//            return
//        }
//    }
}
