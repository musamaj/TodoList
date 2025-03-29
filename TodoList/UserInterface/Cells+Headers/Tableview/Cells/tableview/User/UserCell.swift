//
//  UserCell.swift
//  TodoList
//
//  Created by Usama Jamil on 12/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var lblUsermail  : UILabel!
    @IBOutlet weak var imgTick      : UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblInitials.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        
        // Configure the view for the selected state
        
        if let indexpath = self.indexPath {
            MembersListVM.shared.selectedUserIndex = indexpath.row
        }
    }
    
    func populateData(user: RegisterUser) {
        
        lblInitials.text = user.name?.initials()
        lblUsername.text = user.name
        lblUsermail.text = user.email
    }
    
}
