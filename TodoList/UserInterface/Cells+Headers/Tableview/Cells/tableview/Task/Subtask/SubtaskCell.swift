//
//  SubtaskCell.swift
//  TodoList
//
//  Created by Usama Jamil on 01/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class SubtaskCell: UITableViewCell {

    @IBOutlet weak var btnCheckbox  : UIButton!
    
    var taskDetailVM                = TaskDetailVM()
    var selectedSubtaskId           : String?
    @IBOutlet weak var txtTitle     : UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnCheckbox.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: .normal)
        btnCheckbox.setImage(#imageLiteral(resourceName: "ic_check"), for: .selected)
        
        txtTitle.delegate = self
        txtTitle.returnKeyType = .done
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(viewModel: TaskDetailVM, index: Int) {
        
        self.taskDetailVM  = viewModel
        selectedSubtaskId  = taskDetailVM.subTasks.value[index].id
        
        if let done = taskDetailVM.subTasks.value[index].done, done {
            btnCheckbox.isSelected = done
            txtTitle.isUserInteractionEnabled   = false
            btnCheckbox.tintColor = .lightGray
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskDetailVM.subTasks.value[index].descriptionField ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.avenirMediumFontOfSize(16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, attributeString.length))
            
            self.txtTitle.attributedText = attributeString
            
        } else {
            btnCheckbox.isSelected = false
            txtTitle.isUserInteractionEnabled   = true
            btnCheckbox.tintColor = AppTheme.green2()
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskDetailVM.subTasks.value[index].descriptionField ?? "")
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.avenirMediumFontOfSize(16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), range: NSMakeRange(0, attributeString.length))
            self.txtTitle.attributedText = attributeString
        }
    }
    
    @IBAction func actCheckBox(_ sender: Any) {
        
        if let index = self.indexPath?.row {
            let subtask = taskDetailVM.subTasks.value[index]
            subtask.done = !btnCheckbox.isSelected
            taskDetailVM.updateSubtask(subtask: subtask, params: [App.paramKeys.done: !btnCheckbox.isSelected as AnyObject])
        }
    }
    
    func params()->[String: AnyObject] {
        if let desc = txtTitle.text {
            return [App.paramKeys.desc: desc as AnyObject]
        }
        return [:]
    }
}


extension SubtaskCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if !(txtTitle.text?.isEmpty ?? false) {
                if let index = self.indexPath?.row {
                    let subtask = taskDetailVM.subTasks.value[index]
                    subtask.descriptionField = txtTitle.text
                    taskDetailVM.updateSubtask(subtask: subtask, params: params())
                }
            } else {
                Utility.showSnackBar(msg: App.Validations.requiredStr, icon: nil)
            }
            return false
        }
        
        let isLimit = textView.text.count + (text.count - range.length) <= 200
        
        if isLimit  {
            let _ = textView.getExpandedHeight(taskConstants.maxExpandConstant, false)
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
        
        return isLimit
    }
    
}
