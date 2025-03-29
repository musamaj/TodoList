//
//  Utility.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 15/02/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import UIKit
import Kingfisher
import TTGSnackbar
import SVProgressHUD
import DropDown

//import RNNotificationView

let rootViewController = UIViewController.topViewController()!

class Utility:NSObject {
    

     var centerLabel = UILabel()
    
     static var deleteCallBack : (()->Void)?
    
    // MARK:- Validate internet error or not

    static func isInternetError( _ error: NSError) -> Bool {
        if error.code == -1005 || error.code == -1001 || error.code == -1009 {
            return true
        }
        return false
    }
    
    static func showDeletion() {
        let alert = UIAlertController(title: "", message: App.messages.delWarning, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: App.barItemTitles.delete, style: .destructive , handler:{ (UIAlertAction)in
            Utility.deleteCallBack?()
        }))
        
        alert.addAction(UIAlertAction(title: App.barItemTitles.cancel, style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        // Present the AlertController
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    static func showWarning(_ msg: String = App.messages.revokeWarning, _ cancelBtn: Bool = false) {
        
        // create the alert
        let alert = UIAlertController(title: App.barItemTitles.alert, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: App.barItemTitles.ok, style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            Utility.deleteCallBack?()
        }))
        
        if cancelBtn {
            alert.addAction(UIAlertAction(title: App.barItemTitles.cancel, style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
                alert.dismissMe()
            }))
        }
        
        // show the alert
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func saveUserInfo(authToken: String?, userEmail: String?, userId: String?, username: String?, isLogged: Bool, avatarLink: String?) {
        
        Persistence.shared.isUserAlreadyLoggedIn = isLogged
        
        if let userId = userId {
            Persistence.shared.currentUserID            = userId
        }
        
        if let authToken = authToken {
            Persistence.shared.accessToken = authToken
        }
        
        if let userEmail = userEmail {
            Persistence.shared.currentUserEmail         = userEmail
        }
        
        if let username = username {
            Persistence.shared.currentUserUsername      = username
        }
        
        if let imgUrl = avatarLink {
            Persistence.shared.currentUserUrlHash = imgUrl
        }
    }
    
    static func addControllerAnimation(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        controller.navigationController?.view.layer.add(transition, forKey: nil)
    }
    
    static func navbarDefaultBehaviour(controller: UIViewController) {
        controller.navigationController?.setNavigationBarHidden(false, animated: false)
        controller.navigationController?.navigationBar.isTranslucent = false
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.interactivePopGestureRecognizer?.delegate = controller as? UIGestureRecognizerDelegate
        controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    static func navbarPopGestureDisable(controller: UIViewController) {
        controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    static func navbarPopGestureEnable(controller: UIViewController) {
        controller.navigationController?.interactivePopGestureRecognizer?.delegate = controller as? UIGestureRecognizerDelegate
        controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    static func addLayerToButton(sender:UIButton, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        sender.layer.cornerRadius   = cornerRadius
        sender.layer.borderWidth    = borderWidth
        sender.layer.borderColor    = borderColor
        sender.layer.masksToBounds  = true
    }
    
    static func addLayerToView(sender:UIView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        sender.layer.cornerRadius   = cornerRadius
        sender.layer.borderWidth    = borderWidth
        sender.layer.borderColor    = borderColor
        sender.layer.masksToBounds  = true
    }
    
    static func addLayerToImageView(sender:UIImageView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        sender.layer.cornerRadius   = cornerRadius
        sender.layer.borderWidth    = borderWidth
        sender.layer.borderColor    = borderColor
        sender.layer.masksToBounds  = true
    }
    
    static func addLayerToScrollView(sender:UIScrollView, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        sender.layer.cornerRadius   = cornerRadius
        sender.layer.borderWidth    = borderWidth
        sender.layer.borderColor    = borderColor
        sender.layer.masksToBounds  = true
    }
    
    static func addLayerToLabel(sender:UILabel, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        sender.layer.cornerRadius   = cornerRadius
        sender.layer.borderWidth    = borderWidth
        sender.layer.borderColor    = borderColor
        sender.layer.masksToBounds  = true
    }
    
    class func showSnackBar(msg: String, icon: UIImage?, duration: TTGSnackbarDuration = .middle) {
        
        if msg == "Unauthorized access" {
            AppUtility.sharedInstance.logout()
        } else {
            
            let snackbar = TTGSnackbar(message: msg, duration: duration)
            if let icon = icon {
                snackbar.icon = icon
            }
            if !DeviceType.IS_IPHONE_X || !DeviceType.IS_IPHONE_XR || !DeviceType.IS_IPHONE_XS_MAX {
                snackbar.topMargin = 20
            }
            snackbar.backgroundColor = UIColor.white
            snackbar.messageTextColor = .black
            snackbar.iconContentMode = .scaleAspectFit
            snackbar.animationType = .slideFromTopBackToTop
            snackbar.onSwipeBlock = { (snackbar, direction) in
                
                // Change the animation type to simulate being dismissed in that direction
                if direction == .right {
                    snackbar.animationType = .slideFromLeftToRight
                } else if direction == .left {
                    snackbar.animationType = .slideFromRightToLeft
                } else if direction == .up {
                    snackbar.animationType = .slideFromTopBackToTop
                } else if direction == .down {
                    snackbar.animationType = .slideFromTopBackToTop
                }
                
                snackbar.dismiss()
            }
            
            snackbar.show()
        }
        
    }
    
    class func noDataLabel(controller: UIView, msg: String)-> UILabel {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width: controller.bounds.size.width, height: controller.bounds.size.height))
        noDataLabel.text = msg
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center
        return noDataLabel
    }
    static func showDropDown(anchorView: UIView, dataSource: [String], onItemSelected: @escaping (Int)->()) {
        
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.direction = .top
        dropDown.topOffset = CGPoint(x: 0, y: -50)
        dropDown.dismissMode = .automatic
        dropDown.selectionAction = {(index: Int, item: String) in
            onItemSelected(index)
        }
        
        dropDown.show()
    }
    class func setImage(imgUrl: String?, imageView: UIImageView, placeholderImage: UIImage, aspect: UIView.ContentMode, imageProcessor: Bool = false) {
        
        if let imgString = imgUrl {
            if !imgString.isEmpty {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: URL.init(string: imgString), placeholder: placeholderImage, options: KingfisherOptionsInfo?.none, progressBlock: { (receivedSize, totalSize) in
                }, completionHandler: { (image, error, cacheType, url) in
                    SVProgressHUD.dismiss()
                    if let image = image {
                        imageView.contentMode = aspect
                        imageView.image = image
                    } else {
                        imageView.image = placeholderImage
                    }
                })
            } else {
                imageView.image = placeholderImage
            }
        } else {
            imageView.image = placeholderImage
        }
    }
    
    class func calculateTime(postDate: String)->(String) {
        let postingDate = Utility.date(fromUTCDateString: postDate)!
        let diff = Int(postingDate.timeIntervalSince1970 - Date().timeIntervalSince1970)
        let days = diff/86400
        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        if abs(days) > 0 {
            if abs(days) > 1 {
                return String(abs(days))+" days ago"
            } else {
                return String(abs(days))+" day ago"
            }
        } else if abs(hours) > 0 {
            if abs(hours) > 1 {
                return String(abs(hours))+" hours ago"
            } else {
                return String(abs(hours))+" hour ago"
            }
        } else {
            if abs(hours) > 1 {
                return String(abs(minutes))+" minutes ago"
            } else {
                return String(abs(minutes))+" minute ago"
            }
        }
    }

    // MARK:- TopTabBar
    
    class func openActivity(caption: String?, image: UIImage?, in controller : UIViewController) {
        if let text = caption, let img = image {
            let vc = UIActivityViewController(activityItems: [text,img], applicationActivities: [])
            controller.present(vc, animated: true)
            
        } else if let text = caption {
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            controller.present(vc, animated: true)
        } else if let img = image {
            let vc = UIActivityViewController(activityItems: [img], applicationActivities: [])
            controller.present(vc, animated: true)
        }
        
    }
    
    class func animateLayout(parentView: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            parentView.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK:- Alert Messages
    
    //MARK: - Alert Methods
    
   
    class func showAlert(withTitle title:String, andMessage message:String, onController: UIViewController)
    {
            let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertControl.addAction(action)
            
            onController.present(alertControl, animated: true, completion: {})
    }
    
    
    // MARK:- Helping Methods
    
    /**
     * shows alert to any controller with
     * title, message and a dictionary for button with value of closures and with button titles in key
     * Cancel button should be on second index
     * 1st Index is for default button
     * from third to onward are destructive buttons with red colours
     * to skip any index use this key/value:  "": {($0)}
     */
    
    
    static func showAlert(_ title: String?, message: String?, buttonsDictionary buttons: Dictionary<String, (UIAlertAction?) -> Void>!, baseController parentVC: UIViewController!, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        var count: Int = 0
        for (bTitle, bAction) in buttons {
            if bTitle != "" {
                
                var style: UIAlertAction.Style = UIAlertAction.Style.default
                
                if bTitle == buttonCancel {
                    style = UIAlertAction.Style.cancel
                }
                
                let alertAction: UIAlertAction = UIAlertAction(title: bTitle, style: style, handler: bAction)
                alertController.addAction(alertAction)
            }
            count += 1
        }
        parentVC.presentViewController(alertController)
        
        return alertController
    }
    
    class func strBasedOnCount(count: Int, str: String)-> String {
        var string = "\(count) \(str)s"
        if count <= 1 {
            string = "\(count) \(str)"
        }
        return string
    }
    
    class func followBtnAttributes(selected: Bool, sender: UIButton) {
        if selected {
            sender.isSelected = true
            sender.setTitle("followString", for: .selected)
            sender.backgroundColor      = .blue
            sender.setTitleColor(UIColor.white, for: .selected)
            Utility.addLayerToButton(sender: sender, cornerRadius: 5, borderWidth: 0, borderColor: UIColor.clear.cgColor)
        } else {
            sender.isSelected = false
            sender.setTitle("unfollowString", for: .normal)
            sender.backgroundColor      = UIColor.white
            sender.setTitleColor(UIColor.black, for: .normal)
            Utility.addLayerToButton(sender: sender, cornerRadius: 5, borderWidth: 1.0, borderColor: UIColor.black.cgColor)
        }
    }
    
    class func animateSelection(sender: UIButton, SelectionView: UIView) {
        let position = sender.frame.origin.x
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            SelectionView.frame.origin.x = position
            
        }, completion: nil)
    }
    
    class func animateTable(SelectionView: UIView)
    {
        SelectionView.frame.origin.x = SelectionView.frame.width
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            SelectionView.frame.origin.x = 0
        }, completion: nil)
    }
    
    class func getInitials(str: String)-> String {
        var initials = ""
        let arr = str.split(separator: " ")
        if arr.count > 0 {
            for val in arr {
                if initials.length < 2 {
                    initials += String(val.prefix(1)).capitalized
                }
            }
            return initials
        } else {
            return ""
        }
    }
    
    class func getFirstInitial(str: String)-> String {
        var initials = ""
        let arr = str.split(separator: " ")
        if arr.count > 0 {
            for val in arr {
                if initials.length < 1 {
                    initials += String(val.prefix(1)).capitalized
                }
            }
            return initials
        } else {
            return ""
        }
    }
    
    class func backTwo(newSelf: UIViewController) {
        let viewControllers: [UIViewController] = newSelf.navigationController!.viewControllers as [UIViewController]
        newSelf.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    static func openURL(_ urlString:String) -> Bool {
        
        if urlString.length == 0 {
            print("The URL provided is empty.")
            return false
        }
        
        guard let url = URL(string: urlString) else {
            print("Could not create the NSURL for" + urlString)
            return false
        }
        
        if !application.canOpenURL(url) {
            print("Could not open the NSURL for" + urlString)
            return false
        }
        
        application.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        return true
        
    }
    
    static func getCurrentTimeStamp()-> String {
        
        let date = Date()
        // "Jul 23, 2014, 11:01 AM" <-- looks local without seconds. But:
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd HH:mm:ss ZZZ"
        //let defaultTimeZoneStr = formatter.string(from: date)
        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.string(from: date)
        
        return utcTimeZoneStr
    }
    
    static func date(strDate: String, format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: strDate)
        
        return date
        
    }
    
    static func date(fromUTCDateString dateString: String) -> Date?
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" //"yyyy-MM-dd'T'HH:mm"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    static func convertTimeIntoString(_ hours:Int, minutes:Int, seconds:Int) -> String {
//        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        
        return "\(minuteString):\(secondString)"
    }
    
    static func convertSecnodsIntoTimeComponents(_ num_seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        
        var num_seconds = num_seconds
        
        let hours: Int = num_seconds / (60 * 60)
        num_seconds -= hours * (60 * 60);
        let minutes = num_seconds / 60
        num_seconds -= minutes * 60
        let seconds = num_seconds
        
        return (hours, minutes, seconds)
    }
    
    
    //MARK: - Get Tabbar Height
    
    
    class func getTabBarHeight(in controller : UIViewController) -> CGFloat {
        var tabBarHeight = controller.navigationController?.navigationBar.frame.size.height ?? 0
        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XS_MAX || DeviceType.IS_IPHONE_XR {
            tabBarHeight = tabBarHeight+40
        }
        return tabBarHeight
    }
    
    // MARK: - Network Methods
    class func validateServerResponse(with response: HTTPURLResponse) -> (Bool,String) {
        
        var message = ""
        var isError = false
        
        if response.statusCode == 401 {
            message = "Unauthorized"
            isError = true
        }
        else if response.statusCode == 400 {
            message = "Bad request"
            isError = true
        }
        else if response.statusCode == 402 {
            message = "Unprocessable entity"
            isError = true
        }
        else if response.statusCode == 404 {
            message = "Not found"
            isError = true
        }
        else if response.statusCode == 500 {
            message = "Internal server error"
            isError = true
        }
        return (isError,message)
    }
    
    
}

// MARK:- General functions

func setNavigationBarHidden(self: UIViewController)
{
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.navigationController?.navigationBar.isTranslucent = false
}

func setNavigationBar(self: UIViewController)
{
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.navigationController?.navigationBar.isTranslucent = false
}

func isEmpty(_ text:String?) -> Bool
{
    if text == nil {return true}
    if text!.isEmpty == true {return true}
    return false
}

func isEmail(_ text:String?) -> Bool
{
    let EMAIL_REGEX = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
    return predicate.evaluate(with: text)
}

func isFraction(_ text:String?) -> Bool
{
    let EMAIL_REGEX = "^(?:[1-9][0-9]*)(((?:\\s[1-9][0-9]*)\\/[1-9][0-9]*)|((?:\\/[1-9][0-9]*)*))?$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
    return predicate.evaluate(with: text)
}

func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}

func className(_ name:AnyClass) -> String {
    return name.self.description().components(separatedBy: ".").last!
}

//====================================================================================================

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPHONE_PLUS          = UIDevice.current.userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 2208.0 || UIScreen.main.nativeBounds.height == 1920.0)
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0
    static let IS_IPHONE_XS_MAX          = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2688.0
    static let IS_IPHONE_XR          = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1792.0
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

func removeSpecialCharsFromString( _ text: String) -> String {
    let okayChars : Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
    return String(text.filter {okayChars.contains($0) })
}


//MARK: - Set Post Image Heights

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
