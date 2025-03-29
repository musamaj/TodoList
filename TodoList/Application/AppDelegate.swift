//
//  AppDelegate.swift
//  TodoList
//
//  Created by Usama Jamil on 20/06/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import GoogleSignIn
import MSAL
import CoreData
import IQKeyboardManager
import SVProgressHUD
import Firebase
import Fabric
import Crashlytics
import Reachability
import SwiftQueue
import UserNotifications


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var datastoreCoordinator: DatastoreCoordinator = {
        return DatastoreCoordinator()
    }()
    
    lazy var contextManager: ContextManager = {
        return ContextManager()
    }()
    
    let reachability = Reachability()!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SocketIOManager.sharedInstance.establishConnection()
        if self.reachability.connection == .none {
            JobFactory.setManager()
        }
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        
        NotificationManager.shared.killedState = true
        NotificationManager.shared.setDelegate()
        NotificationManager.shared.registerForPushNotification()   
        SVProgressHUD.setDefaultMaskType(.clear)
        
        self.configureKeyboardManager()
        let _ = ReachabilityManager.init()
        appUtility.firstLoginCheck()
        
        MembersListVM.shared.fetchOnce()
        self.setRootController()
        
        return true
    }
    
    func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setRootController() {
        var mainVC = UIViewController()
        mainVC = MainVC.instantiate(fromAppStoryboard: .Main)
        if Persistence.shared.isUserAlreadyLoggedIn {
            mainVC = CategoryListingVC.instantiate(fromAppStoryboard: .Categories)
        }
        self.window?.rootViewController = UINavigationController.init(rootViewController: mainVC)
    }
    
    func configureKeyboardManager() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    

    func reachabilityListener() {
        
        self.reachability.whenReachable = { reachability in

            if reachability.connection == .wifi {
                //JobFactory.queueManager = nil
                print("Reachable via WiFi")
            } else {
                //JobFactory.queueManager = nil
                print("Reachable via Cellular")
            }
        }
        
        self.reachability.whenUnreachable = { _ in
            print("Not reachable")
            //JobFactory.queueManager = nil
            JobFactory.queueManager?.isSuspended = true
        }
        
        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    // MARK:- Offline First syncing mechanism
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String else {
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        
        return MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: sourceApplication)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //SocketIOManager.sharedInstance.reachability.stopNotifier()
        //SocketIOManager.sharedInstance.closeConnection()
        
        NotificationManager.shared.killedState = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.reachabilityListener()
        //SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Saves changes in the application's managed object context before the application terminates.
        contextManager.saveContext()
    }
    
}

