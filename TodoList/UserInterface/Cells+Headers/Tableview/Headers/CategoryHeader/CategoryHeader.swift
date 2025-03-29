//
//  CategoryHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 05/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CategoryHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSection   : UIButton!
    @IBOutlet weak var imgArrow     : UIImageView!
    @IBOutlet weak var moreBtnWidth : NSLayoutConstraint!
    
    var parent                      : CategoriesAdapter?
    var folderUpdate                = FolderUpdate()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func toggleViewChanges(section: Int) {
        
        if let adapter = self.parent {
            if adapter.viewModel.categoryByFolders[adapter.viewModel.folderKeys[section]]?[0].expanded ?? false {
                self.backgroundView = UIView(frame: self.bounds)
                self.backgroundView?.backgroundColor = .groupTableViewBackground
                self.imgArrow.image = #imageLiteral(resourceName: "ic_arrowdown")
                self.moreBtnWidth.constant = 30
            } else {
                self.backgroundView = UIView(frame: self.bounds)
                self.backgroundView?.backgroundColor = .clear
                self.imgArrow.image = #imageLiteral(resourceName: "ic_backArrow")
                self.moreBtnWidth.constant = 0
            }
        }
    }
    
    func viewConfiguration(adapter: CategoriesAdapter, section: Int) {
        
        self.parent = adapter
        self.toggleViewChanges(section: section)
        
        self.btnSection.tag = section
        self.lblTitle.text  = adapter.viewModel.categoryByFolders[adapter.viewModel.folderKeys[section]]?[0].parentFolder?.name
        self.btnSection.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    }

    @objc func toggleExpand(sender: UIButton) {
        
        if let pAdapter = self.parent {
            
            pAdapter.viewModel.toggleExpand(section: sender.tag)
            pAdapter.categoriesTableView.reloadSections(IndexSet.init(integer: sender.tag), with: .fade)
            
        }
    }
    
    @IBAction func actMore(_ sender: Any) {
        self.showActionsController()
    }
    
    func ungroupCategories() {
        
        if let pAdapter = self.parent {
            if let categories = pAdapter.viewModel.categoryByFolders[pAdapter.viewModel.folderKeys[self.btnSection.tag]] {
                
                let folderItem = categories[0].parentFolder
                folderItem?.rowDeleted = true
                PersistenceManager.sharedInstance.mergeWithMainContext()
                
                for category in categories {
                    let item = pAdapter.viewModel.categoryItems.first { (entity) -> Bool in
                        (entity.id == category.id ?? "" || entity.serverId == category.id ?? "")
                    }
                    item?.folder = nil
                    PersistenceManager.sharedInstance.mergeWithMainContext()
                }
            }
            
            pAdapter.viewModel.fetchData()
        }
        
    }
    
    
    func renameFolder() {
        
        if let pAdapter = self.parent {
            if let categories = pAdapter.viewModel.categoryByFolders[pAdapter.viewModel.folderKeys[self.btnSection.tag]] {
                
                if let folderItem = categories[0].parentFolder {
                    folderUpdate = FolderUpdate.fromNib()
                    
                    if let viewController = UIApplication.topViewController() as? CategoryListingVC {
                        viewController.inputAccessoryTextField.inputAccessoryView = folderUpdate
                        viewController.inputAccessoryTextField.becomeFirstResponder()
                    }
                    
                    folderUpdate.populateData(entity: folderItem)
                }
            }
        }
    }
    
    func showActionsController() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: App.alertKeys.renameFolder, style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            self.renameFolder()
        }))
        alert.addAction(UIAlertAction(title: App.alertKeys.ungroup, style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            self.ungroupCategories()
        }))
        alert.addAction(UIAlertAction(title: App.alertKeys.cancel, style: UIAlertAction.Style.cancel, handler:{ (UIAlertAction)in
            alert.dismissMe()
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
