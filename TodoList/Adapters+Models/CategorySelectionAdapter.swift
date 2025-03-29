//
//  CategorySelectionAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 23/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import UIKit


class CategorySelectionAdapter: NSObject {
    
    weak var categoriesTableView     : UITableView!
    var viewModel                    = CategoryListingVM()
    
    
    init(tableView: UITableView, VM: CategoryListingVM) {
        super.init()
        
        self.viewModel  = VM
        
        tableView.registerNib(from: CategoryCell.self)
        
        categoriesTableView = tableView
        categoriesTableView.backgroundColor = UIColor.white
        
        categoriesTableView.rowHeight = UITableView.automaticDimension
        categoriesTableView.estimatedRowHeight = App.tableCons.estRowHeight
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView(frame: .zero)
        categoriesTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: categoriesTableView.frame.size.width, height: 0.01))
        
        categoriesTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.categoriesTableView.reloadData()
    }
}

extension CategorySelectionAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell : CategoryCell = tableView.dequeue(cell: CategoryCell.self) else { return UITableViewCell() }
        let title = viewModel.categories.value[indexPath.row].name
        cell.populateData(title: title ?? "", index: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
}

extension CategorySelectionAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(viewModel.categories.value[indexPath.row].accepted) {
            Utility.showSnackBar(msg: "Unapprove Recipe", icon: nil)
        } else {
            let viewController = UIApplication.topViewController() as? TaskCreationVC
            viewController?.setSelectedCategory(index: indexPath.row)
        }
    }
}

