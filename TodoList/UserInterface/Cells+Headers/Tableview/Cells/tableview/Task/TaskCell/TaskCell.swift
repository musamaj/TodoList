//
//  TaskCell.swift
//  TodoList
//
//  Created by Usama Jamil on 16/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var btnCheckbox  : UIButton!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDate      : UILabel!
    @IBOutlet weak var BtnAssignee  : UIButton!
    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var initialWidthConstant: NSLayoutConstraint!
    
    var taskVM          = TasksListVM()
    var selectedTask    : TaskData?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnCheckbox.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: .normal)
        btnCheckbox.setImage(#imageLiteral(resourceName: "ic_check"), for: .selected)
        
    }

    // Inside UITableViewCell subclass
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: App.Constants.cellPadding, left: App.Constants.fieldPadding, bottom: App.Constants.cellPadding, right: App.Constants.fieldPadding))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func populateData(viewModel : TasksListVM, data: TaskData) {
        
        taskVM = viewModel
        selectedTask = data
        contentView.setRounded(cornerRadius: App.Constants.defaultRadius-3)
        
        if let username = data.assigneeId?.name {
            self.initialWidthConstant.constant = 30
            lblInitials.text = Utility.getFirstInitial(str: username)
        } else {
            self.initialWidthConstant.constant = 0
        }
        
        if let done = data.done, done {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: data.descriptionField ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.avenirMediumFontOfSize(16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, attributeString.length))
            
            lblTitle.attributedText = attributeString
            btnCheckbox.isSelected = done
            btnCheckbox.tintColor  = .lightGray
            
        } else {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: data.descriptionField ?? "")
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.avenirMediumFontOfSize(16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, attributeString.length))
            
            lblTitle.attributedText = attributeString
            btnCheckbox.isSelected = false
            btnCheckbox.tintColor  = .lightGray
        }
    }
    
    @IBAction func actSelection(_ sender: Any) {
        
        if let id = self.selectedTask?.id, let listId = self.selectedTask?.listId {
            if let _ = self.indexPath?.row {
                taskVM.setSelectedCategory(listId: listId)
                taskVM.update(taskId: id, check: !btnCheckbox.isSelected)
            }
        }
    }
    
}
