//
//  LoginVC.swift
//  TodoList
//
//  Created by Usama Jamil on 25/06/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import GoogleSignIn


struct Login {
    struct params {
        static let name = "name"
        static let email = "email"
        static let pass  = "password"
        static let token = "deviceToken"
    }
}


class LoginVC: BaseVC {

    
    // MARK:- Outlets
    
    
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var txtPassword  : UITextField!
    @IBOutlet weak var btnLogin     : FAButton!
    
    
    // MARK:- Properties
    
    
    var arrFields                   = [UITextField]()
    var loginVM                     : LoginVM?
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginVM = LoginVM.init(parent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.txtEmail.delegate    = self
        self.txtPassword.delegate = self
        self.txtEmail.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // MARK:- Functions
    
    
    @objc func editingChanged(_ textField: UITextField) {
        loginVM?.editingChanged(textField)
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actLogin(_ sender: Any) {
        loginVM?.validateLogin(arrFields: arrFields)
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actForgot(_ sender: Any) {
        show(storyboard: AppStoryboard.Main, identifier: ForgotVC.identifier, configure: nil)
    }
    
}


extension LoginVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
