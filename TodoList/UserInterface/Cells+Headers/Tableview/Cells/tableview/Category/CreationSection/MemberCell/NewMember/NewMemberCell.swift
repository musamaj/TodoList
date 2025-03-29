//
//  NewMemberCell.swift
//  TodoList
//
//  Created by Usama Jamil on 30/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NewMemberCell: ParentSectionCell {

    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var lblTitle     : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblInitials.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(viewModel: AnyObject, _ index: Int = 0) {
        lblInitials.text = "+"
        lblInitials.backgroundColor = AppTheme.lightBlue()
        lblTitle.text = CategoryStrs.addMember
        lblTitle.textColor = AppTheme.lightBlue()
    }
    
}
