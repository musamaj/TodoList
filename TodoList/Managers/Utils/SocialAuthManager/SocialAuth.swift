//
//  SocialAuth.swift
//  TodoList
//
//  Created by Usama Jamil on 25/06/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import GoogleSignIn
import MSAL

enum authType: String {
    case google
    case microsoft
    case facebook
}


class SocialAuth: UIViewController {
    
    var parentVC : UIViewController?
    var type     : authType = .google
    
    let fbManager = FacebookManager()
    let msAuth    = MSAuth()
    
    override func viewDidLoad() {
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func signOut() {
        if type == .google {
            GIDSignIn.sharedInstance()?.signOut()
        } else if type == .microsoft {
            msAuth.signOutMs()
        } else {
            FacebookManager.logout()
        }
    }
    
    func signIn() {
        if type == .google {
            self.callGIDInstance()
        } else if type == .microsoft {
            msAuth.callGraphAPI()
        } else {
            self.callFbClient()
        }
    }
    
    func callGIDInstance() {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func callFbClient() {
        fbManager.loginWithFacebook(self, success: { (userinfo, token) in
            AppUtility.sharedInstance.fbUserInfo = userinfo
            if let email = userinfo["email"] as? String{
                print(email)
            }
        }) { [weak self] (error) in
            Utility.showAlert(withTitle: (error?.localizedDescription)!, andMessage: "", onController: self!)
        }
    }
    
}



//MARK:- Google Auth Delegates



extension SocialAuth: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        parentVC?.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        parentVC?.dismiss(animated: true, completion: nil)
    }
}
