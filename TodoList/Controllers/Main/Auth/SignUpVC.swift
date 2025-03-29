//
//  SignUpVC.swift
//  TodoList
//
//  Created by Usama Jamil on 15/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//
import UIKit

class SignUpVC: BaseVC {
    
    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var fieldsView   : UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var txtPassword  : UITextField!
    @IBOutlet weak var txtConfirm   : UITextField!
    
    @IBOutlet weak var btnRegister  : FAButton!
    
    var arrFields                   = [UITextField]()
    
    var registerVM                  : RegisterVM?
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        registerVM = RegisterVM.init(parent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.txtName.delegate       = self
        self.txtEmail.delegate      = self
        self.txtPassword.delegate   = self
        self.txtConfirm.delegate    = self
        
        self.txtName.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK:- Functions
    
    
    @objc func editingChanged(_ textField: UITextField) {
        registerVM?.editingChanged(textField)
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actRegister(_ sender: Any) {
        registerVM?.validateSignUp(arrFields: arrFields)
    }
    
}


extension SignUpVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
