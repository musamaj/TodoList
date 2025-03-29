//
//  ContactCell.swift
//  TodoList
//
//  Created by Usama Jamil on 30/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var lblUsermail  : UILabel!
    @IBOutlet weak var imgTick      : UIImageView!
    @IBOutlet weak var btnCheckbox  : UIButton!
    @IBOutlet weak var lblType      : UILabel!
    @IBOutlet weak var checkboxWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblInitials.setRounded()
        //lblType.setRounded(10, .yellow)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnCheckbox.isSelected = selected
        
        // Configure the view for the selected state
        
        if let indexpath = self.indexPath {
            MembersListVM.shared.selectedUserIndex = indexpath.row
        }
    }
    
    func setCheckboxImage(normal: UIImage?, selected: UIImage?) {
        btnCheckbox.setImage(normal, for: .normal)
        btnCheckbox.setImage(selected, for: .selected)
    }
    
    func populateData(user: RegisterUser) {
        
        lblInitials.text = user.name?.initials()
        lblUsername.text = user.name
        lblUsermail.text = user.email
        
        if !(user.id?.isEmpty ?? true) || MembersListVM.shared.duplicates.contains(user.email ?? "")  {
            self.setCheckboxImage(normal: nil, selected: nil)
            btnCheckbox.setTitle(App.barItemTitles.added, for: .normal)
            btnCheckbox.setTitleColor(AppTheme.lightBlue(), for: .normal)
            checkboxWidth.constant = 60
            lblType.alpha = 0
            
        } else {
            self.setCheckboxImage(normal: #imageLiteral(resourceName: "ic_untick"), selected: #imageLiteral(resourceName: "ic_tick"))
            btnCheckbox.setTitle("", for: .normal)
            checkboxWidth.constant = 30
            lblType.alpha = 0
        }
        
        if user.id?.contains("-") ?? false {
            lblType.alpha = 1
            
        }
        
    }
    
    
    @IBAction func actSelection(_ sender: Any) {
        //btnCheckbox.isSelected = !btnCheckbox.isSelected
    }
    
}
