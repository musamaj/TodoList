//
//  NoteCell.swift
//  TodoList
//
//  Created by Usama Jamil on 07/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    
    @IBOutlet weak var txtNote  : UITextView!
    @IBOutlet weak var imgNote  : UIImageView!
    
    var taskDetailVM            = TaskDetailVM()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtNote.delegate = self
        txtNote.returnKeyType = .done
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(viewModel: TaskDetailVM) {
        taskDetailVM = viewModel
        txtNote.text = viewModel.taskData.value.note?.replacingOccurrences(of: "\n", with: " ")
        self.setHighlighted(note: txtNote.text)
    }
    
    func setHighlighted(note: String) {
        if note.isEmpty {
            imgNote.isHighlighted = false
        } else {
            imgNote.isHighlighted = true
        }
    }
    
    func updateTask() {
        if !(txtNote.text?.isEmpty ?? false) {
            taskDetailVM.taskData.value.note = txtNote.text
            taskDetailVM.updateTask(params: taskDetailVM.noteParam())
        } else {
            Utility.showSnackBar(msg: App.Validations.requiredStr, icon: nil)
        }
    }
    
}


extension NoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText:String = textView.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        self.setHighlighted(note: updatedText)
        
        if(text == "\n") {
            textView.resignFirstResponder()
            self.updateTask()
            return false
        }
        
        let isLimit = textView.text.count + (text.count - range.length) <= 10000
        if isLimit  {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
        
        return isLimit
    }
    
}
