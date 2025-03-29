//
//  CompleteTaskHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 21/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CompleteTaskHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var btnCompleted : UIButton!
    
    var taskVM  = TasksListVM()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        AppTheme.setNavBartheme(view: btnCompleted)
        btnCompleted.setRounded(cornerRadius: 5)
    }
 
    
    func populateData(viewModel: TasksListVM) {
        
        taskVM = viewModel
        btnCompleted.setTitle(App.toggleKeys.show, for: .normal)
        btnCompleted.setTitle(App.toggleKeys.hide, for: .selected)
    }
    
    
    
    @IBAction func actCompletedTasks(_ sender: Any) {
        btnCompleted.isSelected    = !btnCompleted.isSelected
        taskVM.showCompleted.value = !taskVM.showCompleted.value//btnCompleted.isSelected
    }
    
}
