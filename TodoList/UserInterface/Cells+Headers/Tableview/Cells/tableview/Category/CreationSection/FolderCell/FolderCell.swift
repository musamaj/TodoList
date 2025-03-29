//
//  FolderCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class FolderCell: ParentSectionCell {

    @IBOutlet weak var lblFolderName    : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(viewModel: AnyObject, _ index: Int = 0) {
        self.lblFolderName.text = FoldersListingVM.getFolderName()
    }
    
}
