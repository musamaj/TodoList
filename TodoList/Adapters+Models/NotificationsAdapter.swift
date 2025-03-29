//
//  NotificationsAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 02/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


class NotificationsAdapter: NSObject {
    
    weak var categoriesTableView     : UITableView!
    
    var viewModel                   = NotificationsVM()
    
    
    init(tableView: UITableView, viewModel: NotificationsVM) {
        super.init()
        
        self.viewModel = viewModel
        tableView.registerNib(from: NotifyCell.self)

        categoriesTableView = tableView
        categoriesTableView.backgroundColor = UIColor.white
        
        categoriesTableView.rowHeight = UITableView.automaticDimension
        categoriesTableView.estimatedRowHeight = App.tableCons.estRowHeight
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView(frame: .zero)
        categoriesTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: categoriesTableView.frame.size.width, height: 0.01))
        
        //self.setupRefresh()
        categoriesTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.categoriesTableView.reloadData()
    }
}

extension NotificationsAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel.notifData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : NotifyCell = tableView.dequeue(cell: NotifyCell.self) else { return UITableViewCell() }
        cell.populateData(viewModel: self.viewModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NotificationsAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
