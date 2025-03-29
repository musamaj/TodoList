//
//  MembersListVC.swift
//  TodoList
//
//  Created by Usama Jamil on 12/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import Contacts

class MembersListVC: BaseVC {
    
    
    @IBOutlet weak var searchBar        : UISearchBar!
    @IBOutlet weak var membersTableView : UITableView!
    @IBOutlet weak var searchbarHeighy  : NSLayoutConstraint!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnDon           : UIButton!
    @IBOutlet weak var navBarView       : UIView!
    
    var membersAdapter                  : MembersAdapter?
    var contactsAdapter                 : ContactsAdapter?
    var taskDetailVM                    = TaskDetailVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        MembersListVM.shared.users.removeAll()
        MembersListVM.shared.categoryUsers.value.removeAll()
        
        if let _ = MembersListVM.shared.selectedCategory.id {
            MembersListVM.shared.fetchUsers()
        }
        
        self.viewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppTheme.setNavBartheme(view: self.navBarView)
        self.bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func param(index: Int)-> [String: AnyObject] {
        return [App.paramKeys.assigneeId      : MembersListVM.shared.categoryUsers.value[index].id as AnyObject]
    }
    
    func unassignParam()-> [String: AnyObject] {
        return [App.paramKeys.assigneeId      : taskDetailVM.taskData.value.assigneeId?.id as AnyObject]
    }
    
    func viewConfiguration() {
        
        searchBar.delegate = self

        if let _ = taskDetailVM.taskData.value.id {
            btnCancel.alpha = 0
            searchbarHeighy.constant = 0
            self.membersAdapter = MembersAdapter.init(tableView: self.membersTableView, fetchedData: [""], controller: self)
            MembersListVM.shared.fetchUsers()
        } else {
            
            MembersListVM.shared.duplicates.removeAll()
            MembersListVM.shared.userKeys.removeAll()
            MembersListVM.shared.usersAlphabetically.removeAll()
            
            self.contactsAdapter = ContactsAdapter.init(tableView: self.membersTableView, fetchedData: [""], controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.0) {
                MembersListVM.shared.fetchContacts()
            }
        }
        
    }
    
    func bindViews() {
        
        MembersListVM.shared.categoryUsers.bind { (users) in
            self.membersAdapter?.reloadAdapter()
        }
        
        MembersListVM.shared.allUsers.bind { (users) in
            self.contactsAdapter?.reloadAdapter()
        }
        
        MembersListVM.shared.inviteEmail.bind { (email) in
            self.pop()
        }
    }
    
    func assignTask() {
        
        if let index = MembersListVM.shared.selectedUserIndex {
            
            if index == 0 {
                
                let userData = UserData()
                userData.id = nil
                taskDetailVM.taskData.value.assigneeId = userData
                taskDetailVM.updateTask(params: unassignParam())
                
                MembersListVM.shared.selectedUserIndex = nil
                self.pop()
                
            } else {
                let userData = UserData()
                
                userData.id    = MembersListVM.shared.categoryUsers.value[index].id
                userData.name  = MembersListVM.shared.categoryUsers.value[index].name
                userData.email = MembersListVM.shared.categoryUsers.value[index].email
                
                taskDetailVM.taskData.value.assigneeId = userData
                
                taskDetailVM.updateTask(params: param(index: index))
                MembersListVM.shared.selectedUserIndex = nil
                self.pop()
            }
        }
        
    }
    
    func inviteUsers() {
        
        if let indexPaths = self.membersTableView.indexPathsForSelectedRows {
            MembersListVM.shared.sendInvites(indexPaths: indexPaths)
        } else {
            if let email = searchBar.text, !email.isEmpty, email.isValidEmail() {
                let user = RegisterUser()
                user.email = email
                MembersListVM.shared.syncInvite(user: user)
            }
        }
    }
    
    
    @IBAction func actDone(_ sender: Any) {
        
        if btnDon.titleLabel?.text == App.barItemTitles.add {
            self.inviteUsers()
        } else {
            self.pop()
        }
    }
    
    @IBAction func actCancel(_ sender: Any) {
        self.pop()
    }
    
    
}


extension MembersListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        MembersListVM.shared.filterData(query: searchText.lowercased())
        
        if MembersListVM.shared.userKeys.count == 0 {
            if searchText.isValidEmail() {
                btnDon.setTitle(App.barItemTitles.add, for: .normal)
            } else {
                btnDon.setTitle(App.barItemTitles.done, for: .normal)
            }
        }
    }
    
}
