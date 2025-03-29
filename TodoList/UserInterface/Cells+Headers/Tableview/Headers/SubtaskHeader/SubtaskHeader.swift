//
//  SubtaskHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 01/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class SubtaskHeader: UITableViewHeaderFooterView {

    
    @IBOutlet weak var txtSubtaskTitle  : UITextView!
    var taskDetailVM                    = TaskDetailVM()
    @IBOutlet weak var imgPlus          : UIImageView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        txtSubtaskTitle.delegate = self
        txtSubtaskTitle.returnKeyType = .done
        imgPlus.tintColor = .lightGray
        txtSubtaskTitle.tintColor = AppTheme.green2()
    }
 
    @IBAction func actCreate(_ sender: Any) {
    }
    
}

extension SubtaskHeader : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let viewController = UIApplication.topViewController() as? TaskDetailVC
        viewController?.hidePicker()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            
            if !(textView.text?.isEmpty ?? false) {
                taskDetailVM.addSubtask(params: [App.paramKeys.desc: textView.text as AnyObject])
                txtSubtaskTitle.text?.removeAll()
            } else {
                textView.resignFirstResponder()
            }
            return false
        }
        
        let isLimit = textView.text.count + (text.count - range.length) <= 200
        
        if isLimit  {
            let _ = textView.getExpandedHeight(taskConstants.maxExpandConstant, false)
            UIView.setAnimationsEnabled(false)
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
        return isLimit
    }
    
}
