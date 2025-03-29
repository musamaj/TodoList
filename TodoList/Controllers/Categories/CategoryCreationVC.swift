//
//  CategoryCreationVC.swift
//  TodoList
//
//  Created by Usama Jamil on 10/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//
import UIKit
import PopupKit


class CategoryCreationVC: BaseVC {
    
    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var categorySections: UITableView!
    
    var sectionsAdapter : CategorySectionsAdapter?
    var categoryVM      = CategoryCreationVM()
    
    
    
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
        
        self.setNavBar()
        self.bindViews()
        
        if let _ = categoryVM.categoryData.value.id {
            categoryVM.fetchUsers()
            self.sectionsAdapter?.reloadAdapter()
        } else {
            categoryVM.categoryUsers.value = MembersListVM.shared.selectedUsers
            if CategoryCreationVM.categoryName?.isEmpty ?? true {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    func setNavBar() {
        var rightBarTitle = createStr
        var navTitle      = App.navTitles.listCreation
        
        if let _ = categoryVM.categoryData.value.name {
            rightBarTitle = updateStr
            navTitle      = App.navTitles.editList
        }
        
        self.setDefaults(navTitle, rightStr: rightBarTitle)
        self.setNavigationBar(self)
    }
    
    func viewConfiguration() {
        
        CategoryCreationVM.categoryName?.removeAll()
        
        if categoryVM.categoryData.value.id?.isEmpty ?? true {
            FoldersListingVM.selectedFolder = nil
            FoldersEntity.selectedFolder    = nil
        }
        
        inviteLD.delegate   = categoryVM
        categoryLD.delegate = categoryVM
        
        self.sectionsAdapter = CategorySectionsAdapter.init(tableView: self.categorySections, viewModel: self.categoryVM, controller: self)
        
    }
    
    func bindViews() {
        categoryVM.categoryData.bind{ [weak self] (data) in
            self?.rightButton.isEnabled = true
        }
        
        categoryVM.categoryUsers.bind { [weak self] (data) in
            self?.sectionsAdapter?.reloadAdapter()
        }
        
    }
    
    func inviteAndBind() {
        MembersListVM.shared.selectedCategory = categoryVM.categoryData.value
        self.navigateToMembers(viewModel: TaskDetailVM())
    }
    
    
    // MARK:- Functions
    
    
    override func actRight() {
        
        if let cell = categorySections.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TitleCell, let title = cell.txtTitle.text {
            
            if cell.txtTitle.isValid() {
                self.rightButton.isEnabled = false
                
                if let _ = categoryVM.categoryData.value.name {
                    self.pop()
                } else {
                    self.navigateToTasksListing(category: categoryVM.categoryData.value, item: NSCategory.selectedCategory, parent: self)
                }
                self.callEvents(title: title)
            }
        }
    }
    
    override func actLeft() {
        MembersListVM.shared.selectedUsers.removeAll()
        self.pop()
    }
    
    func callEvents(title: String) {
        categoryVM.create(categoryName: title)
        MembersListVM.shared.inviteSelectedUsers()
    }
    
}
