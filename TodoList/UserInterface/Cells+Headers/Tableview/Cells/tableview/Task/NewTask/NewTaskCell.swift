//
//  NewTaskCell.swift
//  TodoList
//
//  Created by Usama Jamil on 16/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NewTaskCell: UITableViewCell {

    @IBOutlet weak var txtTitle : UITextField!
    var rightBarItem            = UIBarButtonItem()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtTitle.attributedPlaceholder = NSAttributedString(string: CategoryStrs.todoStr,
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtTitle.delegate = self
        txtTitle.returnKeyType = .done
        
        if #available(iOS 11.0, *) {
            txtTitle.textDropDelegate = self
            txtTitle.textDragDelegate = self
        } else {
            // Fallback on earlier versions
        }
        
    }

    // Inside UITableViewCell subclass
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: App.Constants.fieldPadding, bottom: App.Constants.fieldPadding, right: App.Constants.fieldPadding))
        AppTheme.setNavBartheme(view: self.contentView)        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actAdd(_ sender: Any) {
    }
}


extension NewTaskCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(txtTitle.text?.isEmpty ?? false) {
            let controller = UIApplication.topViewController() as! TaskListingVC
            controller.taskCreation()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText:String = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.isEmpty {
            rightBarItem.title = App.barItemTitles.done
        } else {
            rightBarItem.title = App.barItemTitles.add
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        rightBarItem = self.parentContainerViewController?.navigationItem.rightBarButtonItem ?? UIBarButtonItem()
        
        if textField.text?.isEmpty ?? false {
            rightBarItem.title = App.barItemTitles.done
        } else {
            rightBarItem.title = App.barItemTitles.add
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        rightBarItem.title = App.barItemTitles.edit
    }
    
}


extension NewTaskCell: UITextDropDelegate {
    
    @available(iOS 11.0, *)
    func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
        return UITextDropProposal.init(operation: .cancel)
    }
    
}

extension NewTaskCell: UITextDragDelegate {
    
}
