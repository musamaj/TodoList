//
//  CategoryListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CategoryListingVC: BaseVC {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var btnAdd           : UIButton!
    @IBOutlet weak var tblCategories    : UITableView!
    
    var categoriesAdapter               : CategoriesAdapter?
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewConfig()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Utility.navbarPopGestureDisable(controller: self)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK:- Functions
    
    
    func viewConfig() {
        setCustomNav()
        
        btnAdd.setRounded()
        categoriesAdapter = CategoriesAdapter.init(tableView: tblCategories, fetchedData: ["Groceries", "Tuning"], controller: self)
    }
    
    func setCustomNav() {
        Utility.navbarDefaultBehaviour(controller: self)
        self.navigationController?.navigationBar.barTintColor = AppTheme.navBarthemeColor()
        self.navigationController?.navigationBar.tintColor = AppTheme.navBarthemeColor()
        
        //self.navigationItem.title = "Usama"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init()
        
        let button5 = UIButton.init(type: .custom)
        button5.backgroundColor = AppTheme.lightgreen()
        button5.setTitle("M", for: .normal)
        button5.addTarget(self, action: #selector(actLeft1), for: UIControl.Event.touchUpInside)
        button5.frame                                  = CGRect(x: 0, y: 0, width: 35, height: 35)
        button5.setRounded()
        
        let leftButton                                   = UIBarButtonItem(customView: button5)
        
        let leftButton2 = UIBarButtonItem(title: "Muhammad Usama Jamil", style: .plain, target: self, action: #selector(actLeft1))
        leftButton2.tintColor = .white
        
//        let button6 = UIButton.init(type: .custom)
//        button6.backgroundColor = AppTheme.lightgreen()
//        button6.setTitle("Muhammad Usama Jamil", for: .normal)
//        button6.addTarget(self, action: #selector(actRight), for: UIControl.Event.touchUpInside)
//        button6.frame                                  = CGRect(x: 0, y: 0, width: 120, height: 35)
//
//        let stackview = UIStackView.init(arrangedSubviews: [button5, button6])
//        stackview.distribution = .equalSpacing
//        stackview.axis = .horizontal
//        stackview.alignment = .center
//        stackview.spacing = 8
//
//        let leftButton6                                   = UIBarButtonItem(customView: stackview)
        
        self.navigationItem.setLeftBarButtonItems([leftButton, leftButton2], animated: true)
        
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_notification"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(actRight1), for: UIControl.Event.touchUpInside)
        button.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton                                   = UIBarButtonItem(customView: button)
        
        let button1 = UIButton.init(type: .custom)
        button1.setImage(#imageLiteral(resourceName: "ic_msg"), for: UIControl.State.normal)
        button1.addTarget(self, action: #selector(actRight1), for: UIControl.Event.touchUpInside)
        button1.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton2                                  = UIBarButtonItem(customView: button1)
        
        let button2 = UIButton.init(type: .custom)
        button2.setImage(#imageLiteral(resourceName: "ic_search"), for: UIControl.State.normal)
        button2.addTarget(self, action: #selector(actRight1), for: UIControl.Event.touchUpInside)
        button2.frame                                  = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton3                                  = UIBarButtonItem(customView: button2)

        self.navigationItem.setRightBarButtonItems([rightButton, rightButton2, rightButton3], animated: true)
    }
    
    @objc func actLeft1() {
        
    }
    
    @objc func actRight1() {
        
    }
    
    func navigateToCategoryCreation() {
        show(storyboard: AppStoryboard.Categories, identifier: CategoryCreationVC.identifier, configure: nil)
    }
    
    func navigateToTasksListing() {
        show(storyboard: AppStoryboard.Tasks, identifier: TaskListingVC.identifier, configure: nil)
    }
    
    
    @IBAction func actAdd(_ sender: Any) {
        let mainVC = MainVC.instantiate(fromAppStoryboard: .Main)
        var opt = UIWindow.TransitionOptions(direction: .toLeft, style: .easeInOut)
        opt.duration = 0.25
        UIApplication.shared.keyWindow?.setRootViewController(mainVC, options: opt)
    }
    
    @IBAction func actNotify(_ sender: Any) {
    }
    
    @IBAction func actConversation(_ sender: Any) {
    }
    
    @IBAction func actSearch(_ sender: Any) {
    }

}
