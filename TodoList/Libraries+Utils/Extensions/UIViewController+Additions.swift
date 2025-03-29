//
//  UIViewController+Additions.swift
//  LanguageParrot
//
//  Created by Muhammad Azher on 01/08/2016.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit


enum ControllerLoadType {
    case push, present
}

extension UIViewController {


    // MARK:- Load/Instantiate

    static func instantiate(from storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.view.addSubview(child.view)
        }, completion: nil)
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        
        
        UIView.animate(withDuration: 0.5) {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
//        UIView.transition(with: self.view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
//
//        }, completion: nil)
        
        
    }
    
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    // MARK:- Keyboard Editing

    func endEditing() {
        view.endEditing(true)
    }
    
    
    @objc func refreshData() {
        
    }
    
    func hideNav() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNav() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func identifier(from vcClass: UIViewController.Type)-> String {
        return vcClass.identifier
    }
    
    
    // MARK:- Presentation/Dismiss
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.windows.first!.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    fileprivate func dismissPresentedController() {
        self.dismiss(animated: true, completion: { () -> Void in
            print("\(String(describing: type(of: self))) is dismiss.")
        })
    }
    
    fileprivate func dismissPushedController() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func presentViewController(_ viewControllerToPresent: UIViewController) {
        self.presentViewController(viewControllerToPresent, animated: true)
    }
    
    func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        self.present(viewControllerToPresent, animated: flag) { () -> Void in
            print("\(String(describing: type(of: viewControllerToPresent))) is presented.")
        }
    }
    
    func dismissViewController(_ completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    @objc func dismissMe() {
        if let navigationViewController = self.navigationController {
            
            if (navigationViewController.viewControllers.count > 1) {
                dismissPushedController()
            } else {
                dismissPresentedController()
            }
            
        } else {
            dismissPresentedController()
        }
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        endEditing()
        dismissMe()
    }

    func addCancelButton() {
        
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(dismissMe))
        navigationItem.leftBarButtonItem = cancelButton
    }

    
    
    
    // MARK:- NAvigation Fade Affect
    
    func fadeHideNavigation() {
        fadeNavigationBar(withAplha: 0.0)
    }

    func fadeUnHideNavigation() {
        fadeNavigationBar(withAplha: 1.0)
    }

    fileprivate func fadeNavigationBar(withAplha alpha: CGFloat) {
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        if navigationBar.alpha == alpha { return }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.navigationController?.navigationBar.alpha = alpha
        }
    }
    
}

