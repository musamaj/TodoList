//
//  MoreActions.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class MoreActions: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    
    }
    */

    func setTheme() {
        AppTheme.setNavBartheme(view: self)
    }
    
    @IBAction func actEditList(_ sender: Any) {
        
        let tasksListVC = UIApplication.topViewController() as? TaskListingVC
        if let category = TasksListVM.selectedCategory { //, let item = tasksListVC?.tasksVM.categoryItem {
            tasksListVC?.navigateToCategoryCreation(category)
        }
        
    }
    
    @IBAction func actEmailList(_ sender: Any) {
    }
    
}
