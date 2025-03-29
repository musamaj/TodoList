  
  //
  //  BaseVC.swift
  //  ListFixx
  //
  //  Created by Usama Jamil on 13/06/2018.
  //  Copyright © 2018 Square63. All rights reserved.
  //
  import UIKit
  import IQKeyboardManager
  import KRPullLoader
  
  
  class BaseVC: UIViewController {
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler!
    var leftImg         : UIImage?
    var rightImg        : UIImage?
    var leftTitle       : String?
    var rightTitle      : String?
    var navTitle        : String?
    var rightTint       : UIColor?
    var leftTint        : UIColor?
    var titleTint       : UIColor?
    
    weak var globalSelf      : UIViewController?
    
    var shouldReturn    = true
    var enableKeyboardObervers = false
    
    var leftTitleBtn    = UIBarButtonItem()
    var leftButton      = UIBarButtonItem()
    var rightButton     = UIBarButtonItem()
    
    var keyboardHeight : CGFloat  = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if enableKeyboardObervers {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        if shouldReturn {
            returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
            returnKeyHandler.delegate = self as? UITextFieldDelegate & UITextViewDelegate
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Generic NavBar
    
    
    func setDefaults(_ navTitle: String, rightStr: String?) {
        
        self.navTitle = navTitle
        self.leftImg = #imageLiteral(resourceName: "ic_arrowWhite")
        if let title = rightStr {
            self.rightTitle = title
        }
        
        self.leftTint = AppTheme.barItemsTint()
        self.rightTint = AppTheme.barItemsTint()
        self.titleTint = AppTheme.barItemsTint()
    }
    
    func setNavigationBar(_ parent: UIViewController)
    {
        self.globalSelf = parent
        
        if let globalSelf = self.globalSelf {
            Utility.navbarDefaultBehaviour(controller: globalSelf)
            AppTheme.setNavBartheme()

            if let title = self.navTitle {
                globalSelf.navigationItem.title                             = title
            }
            if let tint = self.titleTint {
                globalSelf.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tint]
                
            }
            
            // left bar button item
            if let leftTitle = self.leftTitle {
                leftButton = UIBarButtonItem(title: leftTitle, style: .plain, target: self, action: #selector(actLeft))
                if let leftTint = self.leftTint {
                    leftButton.tintColor = leftTint
                }
                globalSelf.navigationItem.leftBarButtonItem = leftButton
            } else if let leftImg = self.leftImg {
                let button = UIButton.init(type: .custom)
                button.setImage(leftImg, for: UIControl.State.normal)
                button.addTarget(self, action: #selector(actLeft), for: UIControl.Event.touchUpInside)
                button.frame                                = CGRect(x: 0, y: 0, width: 30, height: 30)
                leftButton                                  = UIBarButtonItem(customView: button)
                if let leftTint = self.leftTint {
                    leftButton.tintColor = leftTint
                }
                globalSelf.navigationItem.leftBarButtonItem = leftButton
            }
            
            // right bar button item
            if let rightTitle = self.rightTitle {
                rightButton   = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: #selector(actRight))
                if let rightTint = self.rightTint {
                    rightButton.tintColor = rightTint
                }
                globalSelf.navigationItem.rightBarButtonItem  = rightButton
            } else if let rightImg = self.rightImg {
                let button = UIButton.init(type: .custom)
                button.setImage(rightImg, for: UIControl.State.normal)
                button.addTarget(self, action: #selector(actRight), for: UIControl.Event.touchUpInside)
                button.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
                rightButton                                   = UIBarButtonItem(customView: button)
                globalSelf.navigationItem.rightBarButtonItem  = rightButton
            }
        }
    }
    
    func setNavwithLeftTitle(navTint: UIColor, statusTint: UIColor)
    {
        UIApplication.statusBarBackgroundColor = statusTint
        if let globalSelf = self.globalSelf {
            Utility.navbarDefaultBehaviour(controller: globalSelf)
            globalSelf.navigationController?.navigationBar.barTintColor = navTint
            globalSelf.navigationController?.navigationBar.tintColor = navTint
            
            // left bar button item
            
            if let leftImg = self.leftImg {
                let button = UIButton.init(type: .custom)
                button.setImage(leftImg, for: UIControl.State.normal)
                button.addTarget(self, action: #selector(actLeft), for: UIControl.Event.touchUpInside)
                button.frame                                = CGRect(x: 0, y: 0, width: 30, height: 30)
                leftButton                                  = UIBarButtonItem(customView: button)
                if let leftTint = self.leftTint {
                    leftButton.tintColor = leftTint
                }
            }
            
            if let leftTitle = self.leftTitle {
                leftTitleBtn = UIBarButtonItem(title: leftTitle, style: .plain, target: self, action: #selector(actLeft))
                leftTitleBtn.setTitleTextAttributes([
                    NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 17.0)!],
                                                    for: .normal)
                if let leftTint = self.leftTint {
                    leftTitleBtn.tintColor = leftTint
                }
            }
            
            globalSelf.navigationItem.leftBarButtonItems = [leftButton, leftTitleBtn]
        }
    }
    
    func navColor(color: UIColor) {
        if let globalSelf = self.globalSelf {
            Utility.navbarDefaultBehaviour(controller: globalSelf)
            globalSelf.navigationController?.navigationBar.barTintColor = color
            globalSelf.navigationController?.navigationBar.tintColor = color
        }
    }
    
    func navbarPopGestureDisable() {
        if let globalSelf = self.globalSelf {
            globalSelf.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            globalSelf.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    @objc func actLeft() {
        // override functionality in child controller
        dismiss(delegate: self, animated: true, completion: nil)
    }
    
    @objc func actRight() {
        // override functionality in child controller
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification)
    {
        self.keyboardHeight = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  }
  
  
  // MARK:- NAVIGATION BAR THEMES
  
  extension BaseVC {
    
    func lightYellowNav(_ parent: UIViewController) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
        
        titleTint  = .black
        rightTitle = App.barItemTitles.done
        rightTint  = AppTheme.lightBlue()
        navTitle   = App.navTitles.notes
        
        setNavigationBar(parent)
        navColor(color: AppTheme.lightYellow())
    }
    
  }
  
  
  extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
  }
