//
//  NotificationsVC.swift
//  TodoList
//
//  Created by Usama Jamil on 02/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC {

    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    var notificationsAdaper : NotificationsAdapter?
    let viewModel = NotificationsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel.fetchNotifications()
        notificationsAdaper = NotificationsAdapter.init(tableView: self.notificationsTableView, viewModel: viewModel)
        self.setNavBar()
    }

    
    func setNavBar() {
        
        rightTitle = App.barItemTitles.done
        rightTint  = .white
        navTitle   = App.navTitles.activities
        titleTint  = .white
        setNavigationBar(self)
    }
    
    override func actRight() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
}
