//
//  NewCategoryCell.swift
//  TodoList
//
//  Created by Usama Jamil on 29/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NewCategoryCell: ParentCategoryCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(title: String, index: IndexPath) {
        imgCategory.image = #imageLiteral(resourceName: "ic_plus")
        lblTitle.text = title
    }
    
}
