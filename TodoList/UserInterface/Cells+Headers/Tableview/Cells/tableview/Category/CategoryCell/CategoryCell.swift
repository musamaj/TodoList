//
//  CategoryCell.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class CategoryCell: ParentCategoryCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTaskCount: UILabel!
    @IBOutlet weak var lblStarredCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTaskCount.setRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(title: String, index: IndexPath) {
        lblTitle.text = title
        
        if let controller = UIApplication.topViewController() as? CategoryListingVC {
            let category   = controller.categoryVM.categoryByFolders[controller.categoryVM.folderKeys[index.section]]?[index.row]
            
            if category?.synced ?? false {
                imgCategory.image = R.image.ic_inbox()
            }
            
            if category?.owner?.id == Persistence.shared.currentUserID {
                imgCategory.image = #imageLiteral(resourceName: "ic_list")
            } else {
                imgCategory.image = #imageLiteral(resourceName: "ic_sharedfolder")
            }
            
        }
    }
    
}
