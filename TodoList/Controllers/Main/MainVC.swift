//
//  ViewController.swift
//  TodoList
//
//  Created by Usama Jamil on 20/06/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class MainVC: UIViewController {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        btnSignIn.titleLabel?.halfTextColorChange(fullText: App.Validations.signInStr, changeText: signInSubStr, color: AppTheme.lightBlue())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNav()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK:- Functions
    
    
    // MARK:- IBActions
    
    
    @IBAction func actSignUP(_ sender: Any) {
        show(storyboard: AppStoryboard.Main, identifier: SignUpVC.identifier, configure: nil)
    }
    
    @IBAction func actSignIn(_ sender: Any) {
        show(storyboard: AppStoryboard.Main, identifier: LoginVC.identifier, configure: nil)
    }
    
}
