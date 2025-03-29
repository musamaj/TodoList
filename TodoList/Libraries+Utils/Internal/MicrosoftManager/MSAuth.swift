//
//  MSAuth.swift
//  TodoList
//
//  Created by Usama Jamil on 01/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import MSAL


class MSAuth: NSObject {
    
    let kClientID = "ca690085-ff89-4013-bc02-c9e51f894194"
    let kRedirectUri = "msauth.com.square.ToDoListSTG://auth"
    let kAuthority = "https://login.microsoftonline.com/common"
    
    // Additional variables for Auth and Graph API
    
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    
    var finalResult : Any?
    
    override init() {
        super.init()
        
        do {
            try self.initMSAL()
        } catch let error {
            print(error)
            Utility.showSnackBar(msg: "Unable to create Application Context \(error)", icon: nil)
        }
    }
    
    // Initialize a MSALPublicClientApplication with a given clientID and authority
    
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
    }
    
    // This will invoke the authorization flow.
    
    @objc func callGraphAPI() {
        
        guard let currentAccount = self.currentAccount() else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
    
    
    /**
     This will invoke the call to the Microsoft Graph API. It uses the
     built in URLSession to create a connection.
     */
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Utility.showSnackBar(msg: error.localizedDescription, icon: nil)
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                return
            }
            print(result)
            self.finalResult = result
            
            }.resume()
    }
    
}


// MARK: Get access token


extension MSAuth {
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes)
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                Utility.showSnackBar(msg: error.localizedDescription, icon: nil)
                return
            }
            
            guard let result = result else {
                return
            }
            
            self.accessToken = result.accessToken
            self.getContentWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        // Acquire a token for an existing account silently
        
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                if (nsError.domain == MSALErrorDomain) {
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                return
            }
            
            guard let result = result else {
                return
            }
            
            self.accessToken = result.accessToken
            self.getContentWithToken()
        }
    }
    
}


// MARK: Get account and removing cache


extension MSAuth {
    
    func currentAccount() -> MSALAccount? {
        guard let applicationContext = self.applicationContext else { return nil }
        // We retrieve our current account by getting the first account from cache
        // In multi-account applications, account should be retrieved by home account identifier or username instead
        
        do {
            let cachedAccounts = try applicationContext.allAccounts()
            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }
        } catch let error as NSError {
            Utility.showSnackBar(msg: error.localizedDescription, icon: nil)
        }
        
        return nil
    }
    
    /**
     This action will invoke the remove account APIs to clear the token cache
     to sign out a user from this application.
     */
    
    @objc func signOutMs() {
        
        guard let applicationContext = self.applicationContext else { return }
        guard let account = self.currentAccount() else { return }
        do {
            /**
             Removes all tokens from the cache for this application for the provided account
             - account:    The account to remove from the cache
             */
            
            try applicationContext.remove(account)
            self.accessToken = ""
            
        } catch let error as NSError {
            Utility.showSnackBar(msg: error.localizedDescription, icon: nil)
        }
    }
}

