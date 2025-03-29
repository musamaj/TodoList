//
//  LoginVM.swift
//  TodoList
//
//  Created by Usama Jamil on 25/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import SVProgressHUD


class LoginVM: NSObject {
    
    
    //  MARK:- Properties
    
    
    var token       : Dynamic<String>?
    var user        : Dynamic<RegisterUser>?
    
    var parentVC    = LoginVC()

    
    //  MARK:- init
    
    
    init(parent: LoginVC) {
        super.init()
        
        self.parentVC = parent
        self.viewConfiguration()
    }
    
    
    //  MARK:- Functions
    
    
    func viewConfiguration() {
        
        parentVC.arrFields = [parentVC.txtEmail, parentVC.txtPassword]
        parentVC.btnLogin.disableView()
        
        for field in parentVC.arrFields {
            field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            field.setLeftPaddingPoints(App.Constants.fieldPadding)
        }
    }
    
    func setProperties(response: RegisterData) {
        
        self.token = Dynamic(response.token ?? "")
        if let userData = response.user {
            self.user  = Dynamic(userData)
        }
        
        Utility.saveUserInfo(authToken: response.token, userEmail: response.user?.email, userId: response.user?.id, username: response.user?.name, isLogged: true, avatarLink: nil)
    }
    
    
    //  MARK:- Field Validators
    
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email       = parentVC.txtEmail.text, !email.isEmpty,
            let password    = parentVC.txtPassword.text, !password.isEmpty
            else {
                parentVC.btnLogin.disableView()
                return
        }
        parentVC.btnLogin.disableView(false)
    }
    
    func validateLogin(arrFields: [UITextField]) {
        
        let response =  Validation.shared.validate(values: (type: ValidationType.email, inputValue: arrFields[0].text!))
        switch response {
        case .success:
            self.loginUser()
            break
        case .failure(_, let message):
            print(message.localized())
            Utility.showSnackBar(msg: message.localized(), icon: nil)
        }
    }
    
}



//  MARK:- Network Calls


extension LoginVM {
    
    func params()-> [String: String] {
        return [
            Login.params.email     : parentVC.txtEmail.text ?? "",
            Login.params.pass      : parentVC.txtPassword.text ?? "",
            Login.params.token     : Persistence.shared.deviceID ?? ""
        ]
    }
    
    func loginUser() {
        
        SVProgressHUD.show()
        Auth().Login(self.params(), successBlock: { (LoginResponse) in
            SVProgressHUD.dismiss()
            
            guard let loginResponse = LoginResponse else {return}
            appUtility.firstLoginCheck()
            self.setProperties(response: loginResponse)
            
            SocketIOManager.sharedInstance.establishConnection()
            
            self.parentVC.navigateToHome()
            
        }) { (error) in
            SVProgressHUD.dismiss()
            Utility.showSnackBar(msg: error?.localizedDescription ?? errorStr, icon: nil)
        }
    }
    
}
