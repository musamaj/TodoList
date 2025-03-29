//
//  MemberCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class MemberCell: ParentSectionCell {

    @IBOutlet weak var lblInitials  : UILabel!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblType      : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblInitials.setRounded()
        lblType.setRounded(cornerRadius: 10, width: 1, color: AppTheme.lightBlue())
        lblType.textColor = AppTheme.lightBlue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(viewModel: AnyObject, _ index: Int = 0) {
        
        var username = Persistence.shared.currentUserUsername
        var userId   = Persistence.shared.currentUserID
        var fullname = youStr
        
        if let vm = viewModel as? CategoryCreationVM {
            
            if vm.categoryUsers.value.count > 0 {
                username = vm.getOwnerName()
                userId   = vm.getOwnerId()
                
                if index > 0 {
                    username = vm.getUsername(index: index)
                    userId = vm.getUserId(index: index)
                }
                fullname = persistence.currentUserID == userId ? youStr : username
                
                if userId == vm.categoryData.value.owner?.id {
                    lblType.alpha = 1
                }
            }
            
            if let _ = vm.categoryData.value.id {
                if index == 0 && Persistence.shared.currentUserID == vm.categoryData.value.owner?.id {
                    lblType.alpha = 1
                }
            } else {
                lblType.alpha = 1
            }
            
            self.setType(vm: vm, index)
        }
        
        lblInitials.text = username.initials()
        lblInitials.backgroundColor = AppTheme.lightgreen()
        lblTitle.text = fullname
        lblTitle.textColor = .black
        
    }
    
    func setType(vm: CategoryCreationVM, _ index: Int = 0) {
        
        if index > 0 {
            if let _ = vm.categoryUsers.value[index-1].name {
                lblType.text = App.barItemTitles.owner
            } else {
                lblType.alpha = 1
                lblType.text = App.barItemTitles.pending
            }
        }
    }
    
}
