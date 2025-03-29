//
//  FolderUpdate.swift
//  TodoList
//
//  Created by Usama Jamil on 29/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class FolderUpdate: UIView {

    @IBOutlet weak var txtFolderName    : UITextField!
    
    var folderEntity                    : FoldersEntity?
    
    static var keyboardHeight           : CGFloat = 0
    var topPadding                      : CGFloat = 0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    func populateData(entity: FoldersEntity) {
                
        self.folderEntity = entity
        
        txtFolderName.delegate = self
        txtFolderName.setRounded(cornerRadius: 5, width: 0.5, color: AppTheme.lightBlue())
        txtFolderName.becomeFirstResponder()
        self.txtFolderName.text = entity.name
        
    }
    
    func syncUpdate() {
        FoldersEntity.fetchId = self.folderEntity?.id
        var param = folderLD.updateParam(folderId: self.folderEntity?.id ?? "")
        param[App.paramKeys.fetchID] = self.folderEntity?.id
        
        JobFactory.scheduleJob(param: param, jobType: FolderCreationJob.type, id: self.folderEntity?.id ?? "")
    }
   
    func updateFolder() {
        
        if let viewController = UIApplication.topViewController() as? CategoryListingVC {
            
            if let folderName = txtFolderName.text, !folderName.isEmpty {
                self.folderEntity?.name = folderName
                PersistenceManager.sharedInstance.mergeWithMainContext()
                
                // uncomment it when backend will be working for this
                //self.syncUpdate()
                
                viewController.categoryVM.fetchData()
            }
            
            txtFolderName.resignFirstResponder()
            viewController.inputAccessoryTextField.resignFirstResponder()
        }
    }
    
    @IBAction func actDone(_ sender: Any) {        
        self.updateFolder()
    }
    
}


extension FolderUpdate: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateFolder()
        return true
    }
    
}
