//
//  AssignedCell.swift
//  TodoList
//
//  Created by Usama Jamil on 05/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class AssignedCell: UITableViewCell {

    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var imgProfile   : UIImageView!
    @IBOutlet weak var lblInitials  : UILabel!
    
    var taskDetailVM                = TaskDetailVM()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(viewModel: TaskDetailVM) {
        taskDetailVM     = viewModel
        
        lblInitials.setRounded()
        if let username = viewModel.taskData.value.assigneeId?.name {
            lblInitials.text = Utility.getFirstInitial(str: username)
        }
        lblUsername.text = viewModel.taskData.value.assigneeId?.name
    }
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.assigneeId      : taskDetailVM.taskData.value.assigneeId?.id as AnyObject]
    }
    
    @IBAction func actRemove(_ sender: Any) {
        let userData = UserData()
        userData.id = nil
        taskDetailVM.taskData.value.assigneeId = userData
        taskDetailVM.updateTask(params: param())
    }
    
}
