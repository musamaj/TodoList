//
//  CategoryListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//
import UIKit

class CategoryListingVC: UIViewController {
    
    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var btnAdd           : UIButton!
    @IBOutlet weak var tblCategories    : UITableView!
    @IBOutlet weak var navPaddingView   : UIView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputAccessoryTextField: UITextField!
    
    var categoriesAdapter               : CategoriesAdapter?
    var categoryVM                      = CategoryListingVM()
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setCustomNav()
        AppTheme.setNavBartheme(view: self.navPaddingView)
        
        categoryLD.delegate = categoryVM
        self.bindViews()
        self.bindChanges()
        
        if Persistence.shared.isAppAlreadyLaunchedForFirstTime {
            SocketIOManager.sharedInstance.connected.bind { (isConnected) in
                if isConnected {
                    self.categoryVM.fetchData()
                }
            }
            
        } else {
            self.categoryVM.fetchData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Utility.navbarPopGestureDisable(controller: self)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    
    // MARK:- Functions
    
    
    func viewConfiguration() {
        
        self.btnAdd.setRounded()
        self.categoriesAdapter = CategoriesAdapter.init(tableView: self.tblCategories, fetchedData: [], viewmodel: categoryVM)
    }
    
    func bindViews() {
        categoryVM.categories.bind { [weak self] (data) in
            self?.categoriesAdapter?.reloadAdapter()
        }
    }
    
    func bindChanges() {
        categoryVM.changes.bind { (data) in
            for change in data {
                ChangesManager.shared.handleChange(data: change)
            }
        }
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actAdd(_ sender: Any) {
        
        let viewController = TaskCreationVC.instantiate(fromAppStoryboard: .Tasks)
        self.presentViewController(viewController, animated: true)
    }
    
}
