//
//  SearchesAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 29/01/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


class SearchesAdapter: NSObject {
    
    weak var tasksTableView     : UITableView!
    var tasksVM                 = TasksListVM()
    
    
    init(tableView: UITableView, viewModel: TasksListVM) {
        super.init()
        
        tasksVM = viewModel
        
        tableView.registerNib(from: TaskCell.self)
        tableView.registerNib(from: CompleteTaskHeader.self)
        
        tasksTableView = tableView
        tasksTableView.backgroundColor = .clear
        
        tasksTableView.keyboardDismissMode = .onDrag
        tasksTableView.estimatedRowHeight = App.tableCons.estRowHeight
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.tableFooterView = UIView(frame: .zero)
        tasksTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tasksTableView.frame.size.width, height: 0.01))
        
        tasksTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.tasksTableView.reloadData()
    }
}


extension SearchesAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasksVM.tasksByCategory.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tasksVM.tasksByCategory[tasksVM.categoryKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CompleteTaskHeader.identifier) as? CompleteTaskHeader {
            if let taskData = tasksVM.tasksByCategory[tasksVM.categoryKeys[section]]?[0] {
                headerView.btnCompleted.setTitle(taskData.listName?.uppercased(), for: .normal)
            }
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return App.tableCons.headerHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            Utility.deleteCallBack = {
                if let taskData = self.tasksVM.tasksByCategory[self.tasksVM.categoryKeys[indexPath.section]]?[indexPath.row] {
                    
                    if let listId = taskData.listId {
                        self.tasksVM.setSelectedCategory(listId: listId)
                        self.tasksVM.delete(id: taskData.id ?? "")
                        self.tasksVM.tasksByCategory.removeAll()
                        self.tasksVM.filterData()
                    }
                }
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : TaskCell = tableView.dequeue(cell: TaskCell.self) else { return UITableViewCell() }
        if let taskData = tasksVM.tasksByCategory[tasksVM.categoryKeys[indexPath.section]]?[indexPath.row] {
            cell.populateData(viewModel: tasksVM, data: taskData)
        }
        DispatchQueue.main.async {
            cell.lblInitials.setRounded()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return App.tableCons.defaultHeight+5
    }
    
}

extension SearchesAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TaskDetailVM.delegate = tasksVM
        
        if let taskData = tasksVM.tasksByCategory[tasksVM.categoryKeys[indexPath.section]]?[indexPath.row] {
            
            let item = tasksVM.taskItems.first { (entity) -> Bool in
                (entity.id == taskData.id || entity.serverId == taskData.id)
            }
            TaskEntity.selectedTask = item
            
            NSCategory.fetchId = taskData.listId
            let items = NSCategory.getCategories(byPredicate: true)
            if items.count > 0 {
                let cats = CategoryData().fromNSManagedObject(categories: items)
                UIApplication.topViewController()?.navigateToTaskDetail(task: taskData, category: cats[0])
            }
            
        }
    }
    
}
