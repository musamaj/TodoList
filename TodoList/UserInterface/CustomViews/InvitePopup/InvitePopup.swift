//
//  InvitePopup.swift
//  TodoList
//
//  Created by Usama Jamil on 26/09/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import TTGSnackbar

class InvitePopup: UIView {

    @IBOutlet weak var lblEmail: UITextField!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.setRounded(cornerRadius: 5)
    }
 
    
    
    @IBAction func actSend(_ sender: Any) {
        
        (sender as? UIButton)?.isUserInteractionEnabled = false
        
        if let email = lblEmail.text, !email.isEmpty, email.isValidEmail() {
            
            let index = inviteLD.categoryUsers.firstIndex { (user) -> Bool in
                user.email == email
            }
            
            if email == Persistence.shared.currentUserEmail {
                Utility.showSnackBar(msg: App.Validations.listShared, icon: nil)
                
            } else if let _ = index {
                Utility.showSnackBar(msg: App.Validations.listShared, icon: nil)
                
            } else {
                MembersListVM.shared.invite(email: email)
            }
        } else {
            Utility.showSnackBar(msg: App.Validations.emailValidationStr, icon: nil, duration: .short)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            (sender as? UIButton)?.isUserInteractionEnabled = true
        }
    }
    
}
