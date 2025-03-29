//
//  ProfileHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var imgProfile   : UIImageView!
    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var lblEmail     : UILabel!
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        outerView.setRounded(1, .lightGray)
        lblInitials.setRounded()
    }
 
    
    func populateData() {
        lblInitials.text = Persistence.shared.currentUserUsername.initials()
        lblName.text  = Persistence.shared.currentUserUsername.capitalized
        lblEmail.text = Persistence.shared.currentUserEmail
    }

}
