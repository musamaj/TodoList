//
//  RegisterVM.swift
//  TodoList
//
//  Created by Usama Jamil on 25/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import SVProgressHUD


class RegisterVM: NSObject {

    var parentVC  = SignUpVC()
    
    var token     : Dynamic<String>?
    var user      : Dynamic<RegisterUser>?
    
    
    init(parent: SignUpVC) {
        super.init()
        
        self.parentVC = parent
        self.viewConfiguration()
    }
    
    func viewConfiguration() {
        parentVC.btnRegister.disableView()
        parentVC.fieldsView.setRounded(cornerRadius: App.Constants.defaultRadius)
        
        parentVC.arrFields = [parentVC.txtName, parentVC.txtEmail, parentVC.txtPassword, parentVC.txtConfirm]
        for field in parentVC.arrFields {
            field.setLeftPaddingPoints(App.Constants.fieldPadding)
            field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
    }
    
    
    func setProperties(response: RegisterData) {
        
        self.token = Dynamic(response.token ?? "")
        if let userData = response.user {
            self.user  = Dynamic(userData)
        }
        
        Utility.saveUserInfo(authToken: response.token, userEmail: response.user?.email, userId: response.user?.id, username: response.user?.name, isLogged: true, avatarLink: nil)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let name        = parentVC.txtName.text, !name.isEmpty,
            let email       = parentVC.txtEmail.text, !email.isEmpty,
            let password    = parentVC.txtPassword.text, !password.isEmpty,
            let confirmpassword    = parentVC.txtConfirm.text, !confirmpassword.isEmpty
            else {
                parentVC.btnRegister.disableView()
                return
        }
        parentVC.btnRegister.disableView(false)
    }
    
    
    func validateSignUp(arrFields: [UITextField]) {
        let response =  Validation.shared.validate(values: (type: ValidationType.alphabeticString, inputValue: arrFields[0].text!), (type: ValidationType.email, inputValue: arrFields[1].text!), (type: ValidationType.password, inputValue: arrFields[2].text!), (type: ValidationType.password, inputValue: arrFields[3].text!))
        switch response {
        case .success:
            if arrFields[2].compare(field: arrFields[3]) {
                self.registerUser()
            }
            break
        case .failure(_, let message):
            print(message.localized())
            Utility.showSnackBar(msg: message.localized(), icon: nil)
        }
    }
    
    
}


extension RegisterVM {
    
    func params()-> [String: AnyObject] {
        return [Login.params.name      : (parentVC.txtName.text ?? "") as AnyObject,
                Login.params.email     : (parentVC.txtEmail.text ?? "") as AnyObject,
                Login.params.pass      : (parentVC.txtPassword.text ?? "") as AnyObject,
        ]
    }
    
    func registerUser() {
        SVProgressHUD.show()
        Auth().Register(self.params(), successBlock: { (response) in
            SVProgressHUD.dismiss()
            guard let registerResponse = response else {return}
            appUtility.firstLoginCheck()
            self.setProperties(response: registerResponse)
            
            SocketIOManager.sharedInstance.establishConnection()
            self.parentVC.navigateToHome()
            
        }) { (error) in
            SVProgressHUD.dismiss()
            Utility.showSnackBar(msg: error?.localizedDescription ?? errorStr, icon: nil)
        }
    }
    
}
