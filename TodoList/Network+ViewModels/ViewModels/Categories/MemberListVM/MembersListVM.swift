//
//  MembersListVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper
import PopupKit


class MembersListVM: NSObject {

    
    static let shared   = MembersListVM()
    //var taskDetailVM    = TaskDetailVM()
    
    var categoryUsers   = Dynamic.init([RegisterUser]())
    var allUsers        = Dynamic.init([RegisterUser]())
    
    var userItems       = [SharedUsersEntity]()
    
    var users           = [RegisterUser]()
    var contacts        = [RegisterUser]()
    var phoneContacts   = [RegisterUser]()
    var duplicates      = [String]()
    
    var sharedListId    : String?
    var selectedUserIndex    : Int?
    
    var inviteEmail     = Dynamic.init(String())
    
    var selectedCategory = CategoryData()
    var selectedUsers   = [RegisterUser]()
    var userKeys        = [String]()
    var usersAlphabetically = [String: [RegisterUser]]()
    
    
    // MARK:- Network Calling
    
    
    func params(email: String) -> [String: AnyObject] {
        return [App.paramKeys.listId       : (sharedListId ?? "") as AnyObject,
                App.paramKeys.inviteEmail   : email as AnyObject]
    }
    
    func sendInvites(indexPaths: [IndexPath]) {
        for index in indexPaths {
            if let arrUsers   = self.usersAlphabetically[MembersListVM.shared.userKeys[index.section]] {
                let user = arrUsers[index.row]
                self.syncInvite(user: user)
            }
        }
    }
    
    func syncInvite(user: RegisterUser) {
        
        if let _ = self.selectedCategory.id {
            if let email = user.email, email.isValidEmail() {
                self.invite(email: email)
            }
        } else {
            let contact = RegisterUser()
            contact.email = user.email
            
            if self.selectedUsers.contains(where: { (user) -> Bool in
                user.email == contact.email
            }) {
            } else {
                self.selectedUsers.append(contact)
            }
            UIApplication.topViewController()?.pop()
        }
    }
    
    func inviteSelectedUsers() {
        for user in self.selectedUsers {
            if let email = user.email, email.isValidEmail() {
                self.invite(email: email)
            }
        }
        
        self.selectedUsers.removeAll()
    }
    
}



extension MembersListVM {
    
    func invite(email: String) {
        
        let userData = RegisterUser.initwithParams(email: email)
        let _ = SharedUsersEntity.addUser(userData)
        
        var params                          = MembersListVM.shared.params(email: email)
        params[App.paramKeys.fetchID]       = userData.id as AnyObject
        
        JobFactory.scheduleJob(param: params, jobType: ShareJob.type, id: userData.id ?? "")
        
        self.inviteEmail.value              = email
        
    }
    
    func fetchOnce() {
        ContactsManager.manager.fetchAllContacts { (contacts, error) in
            if contacts.count > 0 {
                for contact in contacts {
                    let user = RegisterUser()
                    user.email = contact.emailAddress
                    user.name  = contact.fullName
                    self.phoneContacts.append(user)
                }
            }
        }
    }
    
    func fetchUsers() {
        
        self.userItems              = SharedUsersEntity.getUsers(true, sortAscending: false, byCategory: true)
        self.users                  = RegisterUser().fromNSManagedObject(users: self.userItems)

        if self.users.isEmpty {
            inviteLD.delegate = self
            inviteLD.fetchUsers()
            
        }
        
        self.setData()
        
    }
    
    func fetchContacts(query: String = "") {
        
        self.contacts = self.phoneContacts
        if self.users.count > 0 {
            self.users.remove(at: 0)
            
            var contactArr = self.contacts
            contactArr.append(contentsOf: self.users)
            
            let groups = Dictionary(grouping: contactArr, by: {$0.email})
            let duplicateGroups = groups.filter {$1.count > 1}
            if let arr = Array(duplicateGroups.keys) as? [String] {
                self.duplicates = arr
            }
        
            
            for dup in duplicates {
                self.users.removeAll { (user) -> Bool in
                    user.email == dup
                }
            }
            
            self.contacts.append(contentsOf: self.users)
        }
        
        self.filterData(query: query)
        
    }
    
    func filterData(query: String) {
        
        self.usersAlphabetically.removeAll()
        
        var filterContacts = self.contacts.filter { (user) -> Bool in
            (user.name?.lowercased().contains(query.lowercased()) ?? true) || (user.email?.lowercased().contains(query.lowercased()) ?? true)
        }
        
        if query.isEmpty  {
            filterContacts = contacts
        }

        self.sortData(filteredContacts: filterContacts)
    }
    
    func sortData(filteredContacts: [RegisterUser]) {
        
        for user in filteredContacts {
            
            let naming = user.name ?? user.email
            if let firstChar = naming?.first {
                
                let dicKey = String(firstChar).lowercased()
                var contactsArr = self.usersAlphabetically[dicKey]
                
                if contactsArr?.count ?? 0 > 0 {
                    contactsArr?.append(user)
                    self.usersAlphabetically[dicKey] = contactsArr
                } else {
                    self.usersAlphabetically[dicKey] = [user]
                }
                
            }
        }
        
        self.userKeys = self.usersAlphabetically.keys.sorted()
        
        self.allUsers.value = self.contacts
    }
    
    func setData() {
        let userData   = RegisterUser()
        userData.id    = TasksListVM.selectedCategory?.owner?.id
        userData.name  = TasksListVM.selectedCategory?.owner?.name
        userData.email = TasksListVM.selectedCategory?.owner?.email
        
        if let _ = userData.id {
            self.users.append(userData)
        }
        
        if AppDelegate().reachability.connection == .none || self.users.count == 0 {
            let currentUser = RegisterUser()
            if Persistence.shared.currentUserID != userData.id {
                currentUser.id  = Persistence.shared.currentUserID
                currentUser.name = Persistence.shared.currentUserUsername
                currentUser.email = Persistence.shared.currentUserEmail
                
                self.users.append(currentUser)
            }
        }
        
        let unassignedUser = RegisterUser()
        unassignedUser.name = App.paramKeys.unassigned
        
        self.users.insert(unassignedUser, at: 0)
        self.categoryUsers.value = self.users
    }
    
    func handleUsers() {
        
        // local implementation is here
        
        self.users = inviteLD.categoryUsers
        CategoryListingVM.sharedUsers  = inviteLD.categoryUsers
        self.setData()
        self.fetchContacts()
        
        SharedUsersEntity.deleteByPredicate(entity: SharedUsersEntity.identifier)
        SharedUsersEntity.saveUsers(inviteLD.categoryUsers)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userItems    = SharedUsersEntity.getUsers()
        }
    }
    
}




// MARK:- Sockets Delegate


extension MembersListVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .users {
            self.handleUsers()
        }
    }
    
    func failure(type: responseTypes) {}
}

