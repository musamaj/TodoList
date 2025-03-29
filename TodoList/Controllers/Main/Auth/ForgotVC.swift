//
//  ForgotVC.swift
//  TodoList
//
//  Created by Usama Jamil on 15/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//
import UIKit

class ForgotVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var btnForgot    : FAButton!
    
    var forgotVM                    : ForgotVM?
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        forgotVM = ForgotVM.init(parent: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.txtEmail.delegate = self
        self.txtEmail.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.txtEmail.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Functions
    
    
    @objc func editingChanged(_ textField: UITextField) {
        forgotVM?.editingChanged(textField)
    }
    
    
    // MARK: - Functions
    
    
    @IBAction func actReset(_ sender: Any) {
        forgotVM?.validateForgot(field: txtEmail)
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ForgotVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
