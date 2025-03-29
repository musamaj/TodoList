//
//  MembersAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 12/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class MembersAdapter: NSObject {
    
    weak var membersTableView        : UITableView!
    var parentVC                     : MembersListVC?
    
    
    init(tableView: UITableView, fetchedData:[String], controller: MembersListVC?) {
        super.init()
        
        parentVC = controller
        
        tableView.registerNib(from: UserCell.self)
        
        membersTableView = tableView
        membersTableView.backgroundColor = .white
        
        membersTableView.estimatedRowHeight = App.tableCons.defaultHeight
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.tableFooterView = UIView(frame: .zero)
        membersTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: membersTableView.frame.size.width, height: 0.01))
        
        membersTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.membersTableView.reloadData()
    }
}

extension MembersAdapter : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MembersListVM.shared.categoryUsers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : UserCell = tableView.dequeue(cell: UserCell.self) else { return UITableViewCell() }
        cell.populateData(user: MembersListVM.shared.categoryUsers.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryStrs.tableCons.cellHeight
    }
    
}

extension MembersAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentVC?.assignTask()
    }
}
