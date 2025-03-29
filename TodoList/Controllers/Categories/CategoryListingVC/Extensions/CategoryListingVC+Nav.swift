//
//  CategoryListingVC+Nav.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


extension CategoryListingVC {
    
    func setCustomNav() {
        
        Utility.navbarDefaultBehaviour(controller: self)
        AppTheme.setNavBartheme()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init()
        
        let btnInitials             = UIButton.init(type: .custom)
        btnInitials.backgroundColor = AppTheme.lightgreen()
        btnInitials.setTitle(Persistence.shared.currentUserUsername.initials(), for: .normal)
        btnInitials.addTarget(self, action: #selector(actLeft), for: UIControl.Event.touchUpInside)
        btnInitials.frame                                    = CGRect(x: 0, y: 0, width: 35, height: 35)
        btnInitials.setRounded()
        
        let barBtnInitials                                   = UIBarButtonItem(customView: btnInitials)
        let btnTitle                                         = UIBarButtonItem(title: Persistence.shared.currentUserUsername.capitalized, style: .plain, target: self, action: #selector(actLeft))
        
        btnTitle.tintColor = .white
        
        self.navigationItem.setLeftBarButtonItems([barBtnInitials, btnTitle], animated: true)
        
        let btnNotify = UIButton.init(type: .custom)
        btnNotify.setImage(#imageLiteral(resourceName: "ic_notification"), for: UIControl.State.normal)
        btnNotify.addTarget(self, action: #selector(actNotif), for: UIControl.Event.touchUpInside)
        btnNotify.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barBtnNotify                                   = UIBarButtonItem(customView: btnNotify)
        
//        let btnMsg = UIButton.init(type: .custom)
//        btnMsg.setImage(#imageLiteral(resourceName: "ic_msg"), for: UIControl.State.normal)
//        btnMsg.tintColor = .white
//        btnMsg.addTarget(self, action: #selector(actMSg), for: UIControl.Event.touchUpInside)
//        btnMsg.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
//        
//        let barBtnMsg                                  = UIBarButtonItem(customView: btnMsg)
        
        let btnSearch = UIButton.init(type: .custom)
        btnSearch.setImage(#imageLiteral(resourceName: "ic_searchbar"), for: UIControl.State.normal)
        btnSearch.addTarget(self, action: #selector(actionSearch), for: UIControl.Event.touchUpInside)
        btnSearch.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barBtnSearch                                  = UIBarButtonItem(customView: btnSearch)
        
        self.navigationItem.setRightBarButtonItems([barBtnNotify, barBtnSearch], animated: true)
        
    }
    
    @objc func actLeft() {
        self.navigateToProfile()
    }
    
    @objc func actNotif() {
        self.navigateToNotifications()
    }
    
    @objc func actMSg() {
        
    }
    
    @objc func actionSearch() {
        self.navigateToSearch()
    }
    
}
