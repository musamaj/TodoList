//
//  ForgotVM.swift
//  TodoList
//
//  Created by Usama Jamil on 25/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import SVProgressHUD


class ForgotVM: NSObject {

    var parentVC  = ForgotVC()
    var message   : Dynamic<String> = Dynamic("")
    
    
    init(parent: ForgotVC) {
        super.init()
        
        self.parentVC = parent
        self.viewConfiguration()
    }
    
    func viewConfiguration() {
        
        self.message.bind { [weak self] in
            self?.parentVC.txtEmail.text = $0
            self?.parentVC.pop()
        }
        
        parentVC.txtEmail.setLeftPaddingPoints(App.Constants.fieldPadding)
        parentVC.txtEmail.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        parentVC.btnForgot.disableView()
    }
    
    func validateForgot(field: UITextField) {
        let response =  Validation.shared.validate(values: (type: ValidationType.email, inputValue: field.text!))
        switch response {
        case .success:
            self.retrievePwd()
            break
        case .failure(_, let message):
            print(message.localized())
            Utility.showSnackBar(msg: message.localized(), icon: nil)
        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let email = parentVC.txtEmail.text, !email.isEmpty
            else {
                parentVC.btnForgot.disableView()
                return
        }
        parentVC.btnForgot.disableView(false)
    }
    
}


extension ForgotVM {
    
    func params()-> [String: String] {
        return [
            Login.params.email     : parentVC.txtEmail.text ?? ""
        ]
    }
    
    func retrievePwd() {
        SVProgressHUD.show()
        Auth().ForgotPwd(self.params(), successBlock: { (ForgotResponse) in
            
            SVProgressHUD.dismiss()
            guard let forgotResponse = ForgotResponse else {return}
            //self.message = Dynamic(forgotResponse)
            self.message.value = forgotResponse
            Utility.showSnackBar(msg: App.Validations.forgotStr, icon: nil)
            
        }) { (error) in
            SVProgressHUD.dismiss()
            Utility.showSnackBar(msg: error?.localizedDescription ?? errorStr, icon: nil)
        }
    }
    
}
