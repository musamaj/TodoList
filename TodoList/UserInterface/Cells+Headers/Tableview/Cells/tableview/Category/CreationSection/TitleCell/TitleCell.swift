//
//  TitleCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class TitleCell: ParentSectionCell {

    @IBOutlet weak var txtTitle : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtTitle.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if TasksListVM.selectedCategory?.name?.isEmpty ?? true {
                self.txtTitle.becomeFirstResponder()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(viewModel : AnyObject, _ index: Int = 0) {
        txtTitle.delegate = self
        txtTitle.text = TasksListVM.selectedCategory?.name ?? CategoryCreationVM.categoryName
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if let controller = UIApplication.topViewController() as? CategoryCreationVC {
            
            let barItem = controller.navigationItem.rightBarButtonItem
            
            if textField.text?.count == 1 {
                if textField.text?.first == " " {
                    textField.text = ""
                    return
                }
            }
            guard let title = self.txtTitle.text, !title.isEmpty
                else {
                    barItem?.isEnabled = false
                    return
            }
            CategoryCreationVM.categoryName = title
            barItem?.isEnabled = true
        }
    }
    
}


extension TitleCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
