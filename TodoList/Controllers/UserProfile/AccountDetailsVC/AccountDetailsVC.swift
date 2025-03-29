//
//  AccountDetailsVC.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


// MARK:- Constants


struct ProfileCons {
    static let sectionHeights : [CGFloat] = [180, 50,  50]
    static let sections    = ["Header", "ACCOUNT", "GENERAL"]
    static let data        = [ 0 : [],
                               1 : ["Sign Out"],
                               2 : ["Background"]]//"Change Name", "Change Password"]]
    static let images      = [ 0 : [#imageLiteral(resourceName: "ic_user")],
                               1 : [#imageLiteral(resourceName: "ic_logout")],
                               2 : [UIImage.init(named: "ic_image")]]//, #imageLiteral(resourceName: "ic_lock")]]
}


// MARK:- Controller Methods


class AccountDetailsVC: BaseVC {

    
    // MARK:- Properties
    
    var profileAdapter                  : UserProfileAdapter?
    
    
    @IBOutlet weak var profileTableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    func viewConfiguration() {
        
        self.setDefaults(App.navTitles.profile, rightStr: nil)
        self.setNavigationBar(self)
        AppTheme.setNavBartheme(VC: self)
        
        profileAdapter = UserProfileAdapter.init(tableView: self.profileTableView, fetchedData: [], controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewConfiguration()
    }
    
}
