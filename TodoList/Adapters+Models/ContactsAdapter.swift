//
//  ContactsAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 27/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit


class ContactsAdapter: NSObject {
    
    weak var contactsTableView        : UITableView!
    var parentVC                     : MembersListVC?
    var togle = false
    
    init(tableView: UITableView, fetchedData:[String], controller: MembersListVC?) {
        super.init()
        
        parentVC = controller
        
        tableView.registerNib(from: ContactCell.self)
        contactsTableView = tableView
        
        contactsTableView.estimatedRowHeight = App.tableCons.defaultHeight
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.contactsTableView.reloadData()
    }
}

extension ContactsAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MembersListVM.shared.userKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MembersListVM.shared.usersAlphabetically[MembersListVM.shared.userKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : ContactCell = tableView.dequeue(cell: ContactCell.self) else { return UITableViewCell() }
        if let arrUsers   = MembersListVM.shared.usersAlphabetically[MembersListVM.shared.userKeys[indexPath.section]] {
            cell.populateData(user: arrUsers[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryStrs.tableCons.cellHeight
    }
    
}

extension ContactsAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let arrUsers   = MembersListVM.shared.usersAlphabetically[MembersListVM.shared.userKeys[indexPath.section]] {
            let user = arrUsers[indexPath.row]
            if user.id?.isEmpty ?? true {
                let viewController = UIApplication.topViewController() as? MembersListVC
                viewController?.btnDon.setTitle(App.barItemTitles.add, for: .normal)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.indexPathsForSelectedRows?.count ?? 0 == 0 {
            let viewController = UIApplication.topViewController() as? MembersListVC
            viewController?.btnDon.setTitle(App.barItemTitles.done, for: .normal)
        }
    }
}
