//
//  ListAcceptenceCell.swift
//  TodoList
//
//  Created by Usama Jamil on 15/01/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class ListAcceptenceCell: UITableViewCell {

    @IBOutlet weak var lblInitial       : UILabel!
    @IBOutlet weak var lblCategoryName  : UILabel!
    @IBOutlet weak var lblOwner         : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func getCategory()-> (NSCategory?,CategoryData?, CategoryListingVM?) {
        
        if let controller = UIApplication.topViewController() as? CategoryListingVC {
            let viewModel = controller.categoryVM
            
            //guard let indexP = controller.tblCategories.indexPath(for: self) else { return (nil, nil, nil) }
            
            if let category = viewModel.categoryByFolders[viewModel.folderKeys[lblInitial.tag]]?[lblOwner.tag] {
                let item = viewModel.categoryItems.first { (entity) -> Bool in
                    (entity.id == category.id || entity.serverId == category.id)
                }
                
                return (item,category, viewModel)
            }
        }
        
        return (nil, nil, nil)
    }
    
    
    func populateData() {
        
        let (_, category, _) = self.getCategory()
        
        self.lblInitial.setRounded()
        if let username = category?.owner?.name {
            self.lblInitial.text = Utility.getFirstInitial(str: username)
            self.lblOwner.text        = "From \(username)"
        }
        if let name = category?.name {
            self.lblCategoryName.text = name
        }
    }
    
    func Param(_ category: CategoryData, accepted: Bool)-> [String: Any] {
        return [App.paramKeys.accepted : accepted,
                App.paramKeys.listId   : category.id as Any,
                App.paramKeys.userId   : Persistence.shared.currentUserID
        ]
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actReject(_ sender: Any) {
                
        Utility.deleteCallBack = {
            
            let (item, category, viewModel) = self.getCategory()
            
            item?.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
            
            viewModel?.fetchData()
            
            if let cat = category {
                var param      = self.Param(cat, accepted: false)
                param[App.paramKeys.fetchID] = cat.id
                JobFactory.scheduleJob(param: param, jobType: CategoryApprovalJob.type, id: cat.id ?? "")
            }
        }
        Utility.showDeletion()
    }
    
    @IBAction func actAccept(_ sender: Any) {
        
        let (item, category, viewModel) = self.getCategory()
        
        item?.accepted = true
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        viewModel?.fetchData()
        
        if let cat = category {
            var param = self.Param(cat, accepted: true)
            param[App.paramKeys.fetchID] = cat.id
            JobFactory.scheduleJob(param: param, jobType: CategoryApprovalJob.type, id: cat.id ?? "")
        }
    }
    
}
