//
//  AppDataManager.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 06/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import UIKit
import AVFoundation
import MobileCoreServices
import KRPullLoader
import Alamofire

public enum AppStoryboard : String
{
    case Main
    case Categories
    case Tasks
    case UserProfile
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T
    {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController?
    {
        return instance.instantiateInitialViewController()
    }
}

class AppUtility: NSObject {
    
    
    // MARK:- Shared

    static let sharedInstance = AppUtility()
    
    //  MARK:- Class Properties

    var activeViewController             : UIViewController!
    var userProfilePhoto                 = ""
    fileprivate  var _fbUserInfo         : [String:AnyObject]?
    fileprivate  var _amazonUserInfo     : [String:AnyObject]?
    fileprivate  var _UserInfo           : [String:AnyObject]?
    
    
    func apiHeader()-> HTTPHeaders {
        guard let accessToken = Persistence.shared.accessToken else {return ["":""]}
        let headers: HTTPHeaders = [
            authEmailKey  : Persistence.shared.currentUserEmail,
            authHeaderKey : accessToken
        ]
        
        return headers
    }
    
    func authHeader()-> HTTPHeaders {
        let headers :HTTPHeaders = [
            contentTypeKey   : jsonContentType
        ]
        
        return headers
    }
    
    func firstLoginCheck() {
        if Persistence.shared.isUserAlreadyLoggedIn {
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = !Persistence.shared.isUserAlreadyLoggedIn
        } else {
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = !Persistence.shared.isUserAlreadyLoggedIn
        }
    }
    
    func setupRefreshControls(controller: UIViewController, tableView: UIScrollView) {
        let refreshControl = KRPullLoadView()
        let pullrefreshControl = KRPullLoadView()
        refreshControl.delegate = controller as? KRPullLoadViewDelegate
        pullrefreshControl.delegate = controller as? KRPullLoadViewDelegate
        tableView.addPullLoadableView(refreshControl, type: .loadMore)
        tableView.addPullLoadableView(pullrefreshControl, type: .refresh)
        pullrefreshControl.messageLabel.text = "Pull to refresh"
    }
    
    func setupCollectionRefreshControls(collectionView: UICollectionView) {
        collectionView.addPullLoadableView(HorizontalPullLoadView(), type: .refresh)
        collectionView.addPullLoadableView(HorizontalPullLoadView(), type: .loadMore)
    }
    
    func incrementPage(indexPath: IndexPath, page: Int)-> Int {
        if (indexPath.row+1)%(page*perPageItems) == 0 && indexPath.row > 0 {
             return ((indexPath.row+1)/perPageItems)+1
        }
        return page
    }
    
    func incrementPage(indexPath: Int, page: Int)-> Int {
        if (indexPath+1)%(page*perPageItems) == 0 && indexPath > 0 {
            return ((indexPath+1)/perPageItems)+1
        }
        return page
    }
    
    func logout() {
        SocketIOManager.sharedInstance.closeConnection()
        PersistenceManager.sharedInstance.deleteAllRecords(entity: NSCategory.identifier)
        PersistenceManager.sharedInstance.deleteAllRecords(entity: FoldersEntity.identifier)
        Persistence.shared.removeAllPersitedData()
        JobFactory.queueManager?.cancelAllOperations()
        NotificationManager.shared.cancellAll()
    }
    
    var fbUserInfo:[String:AnyObject]? {
        get {
            if _fbUserInfo == nil { _fbUserInfo = userDefaults.object(forKey: keyFbUserInfo) as? [String:AnyObject]}
            return _fbUserInfo
        }
        set {
                _fbUserInfo = newValue
                userDefaults.set(_fbUserInfo, forKey:keyFbUserInfo)
                userDefaults.synchronize()
        }
    }
    
    var amazonUserInfo:[String:AnyObject]? {
        get {
            if _amazonUserInfo == nil { _amazonUserInfo = userDefaults.object(forKey: keyAmazonUserInfo) as? [String:AnyObject]}
            return _amazonUserInfo
        }
        set {
            _amazonUserInfo = newValue
            userDefaults.set(_amazonUserInfo, forKey:keyAmazonUserInfo)
            userDefaults.synchronize()
        }
    }
    
    var UserInfo:[String:AnyObject]? {
        get {
            if _UserInfo == nil { _UserInfo = userDefaults.object(forKey: keyUserInfo) as? [String:AnyObject]}
            return _UserInfo
        }
        set {
            _UserInfo = newValue
            userDefaults.set(_UserInfo, forKey:keyUserInfo)
            userDefaults.synchronize()
        }
    }
    
    fileprivate var _appAuthToken:String?
    var appAuthToken:String? {
        get {
            if _appAuthToken == nil { _appAuthToken = userDefaults.object(forKey: keyAuthToken) as? String}
            return _appAuthToken
        }
        
        set {
            if _appAuthToken != newValue {
                _appAuthToken = newValue
                userDefaults.set(_appAuthToken, forKey:keyAuthToken)
                userDefaults.synchronize()
            }
        }
    }
    
    fileprivate var _appTheme:Int?
    var appTheme:Int? {
        get {
            if _appTheme == nil { _appTheme = userDefaults.object(forKey: keyAppTheme) as? Int}
            return _appTheme
        }
        
        set {
            if _appTheme != newValue {
                _appTheme = newValue
                userDefaults.set(_appTheme, forKey:keyAppTheme)
                userDefaults.synchronize()
            }
        }
    }
    
    fileprivate var _currentUserEmail:String?
    var currentUserEmail:String? {
        get {
            if _currentUserEmail == nil { _currentUserEmail = userDefaults.object(forKey: keyCurrentUserEmail) as? String}
            return _currentUserEmail
        }
        
        set {
            if _currentUserEmail != newValue {
                _currentUserEmail = newValue
                userDefaults.set(_currentUserEmail, forKey:keyCurrentUserEmail)
                userDefaults.synchronize()
            }
        }
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIViewController
{
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self
    {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension Notification.Name {
    static let popTab = Notification.Name("pop")
}


extension UIView {
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

extension Dictionary {
    
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    var categoryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)/\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}

extension UITableView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
}
