//
//  NewFolderCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NewFolderCell: UITableViewCell {

    @IBOutlet weak var txtFolderName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtFolderName.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func barItemChanges(title: String) {
        
        if let viewController = UIApplication.topViewController() {
            let rightBarItem = viewController.navigationItem.rightBarButtonItem
            rightBarItem?.title = title
        }
    }
    
}


extension NewFolderCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.barItemChanges(title: App.barItemTitles.done)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.barItemChanges(title: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.isEmpty ?? true {
            FoldersListingVM.selectedFolder = nil
            self.barItemChanges(title: "")
            
        } else {
            FoldersListingVM.selectedFolder = textField.text
            UIApplication.topViewController()?.pop()
        }
        
        return true
    }
    
}
