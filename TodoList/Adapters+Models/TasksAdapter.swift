//
//  TasksAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import MobileCoreServices


class TasksAdapter: NSObject {
    
    weak var tasksTableView     : UITableView!
    var tasksVM                 = TasksListVM()
    var extraRow                = [1,0]
    
    
    init(tableView: UITableView, fetchedData:[String], viewModel: TasksListVM) {
        super.init()
        
        tasksVM = viewModel
        
        tasksTableView = tableView
        
        tasksTableView.registerNib(from: NewTaskCell.self)
        tasksTableView.registerNib(from: TaskCell.self)
        tasksTableView.registerNib(from: CompleteTaskHeader.self)
        
        tasksTableView.backgroundColor = .clear
        
        tasksTableView.keyboardDismissMode = .onDrag
        tasksTableView.estimatedRowHeight = App.tableCons.estRowHeight
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        self.configureDragDrop()
        
        tasksTableView.tableFooterView = UIView(frame: .zero)
        tasksTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tasksTableView.frame.size.width, height: 0.01))
        
        tasksTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.tasksTableView.reloadData()
    }
}


extension TasksAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = tasksVM.completedTasks.value.count > 0 ? 2 : 1
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1 && !(tasksVM.showCompleted.value) {
            return 0
        }
        
        let rows = section == 0 ? (tasksVM.uncompletedTasks.value.count) + extraRow[section] : tasksVM.completedTasks.value.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CompleteTaskHeader.identifier) as? CompleteTaskHeader {
                headerView.populateData(viewModel: tasksVM)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return App.tableCons.headerHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            Utility.deleteCallBack = {
                let taskData = indexPath.section == 0 ? self.tasksVM.uncompletedTasks.value[indexPath.row-1] : self.tasksVM.completedTasks.value[indexPath.row]
                self.tasksVM.delete(id: taskData.id ?? "")
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let cell : NewTaskCell = tableView.dequeue(cell: NewTaskCell.self) else { return UITableViewCell() }
            cell.contentView.setRounded(cornerRadius: App.Constants.defaultRadius-3)
            return cell
            
        } else {
            guard let cell : TaskCell = tableView.dequeue(cell: TaskCell.self) else { return UITableViewCell() }
            let taskData = indexPath.section == 0 ? tasksVM.uncompletedTasks.value[indexPath.row-1] : tasksVM.completedTasks.value[indexPath.row]
            cell.populateData(viewModel: tasksVM, data: taskData)
            DispatchQueue.main.async {
                cell.lblInitials.setRounded()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            return App.tableCons.taskCell
        }
        return App.tableCons.defaultHeight+5
    }
    
}

extension TasksAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TaskDetailVM.delegate = tasksVM
        
        if indexPath.row > 0 || indexPath.section == 1 {
            let taskData = indexPath.section == 0 ? tasksVM.uncompletedTasks.value[indexPath.row-1] : tasksVM.completedTasks.value[indexPath.row]
            let item = tasksVM.taskItems.first { (entity) -> Bool in
                (entity.id == taskData.id || entity.serverId == taskData.id)
            }
            TaskEntity.selectedTask = item
            UIApplication.topViewController()?.navigateToTaskDetail(task: taskData, category: TasksListVM.selectedCategory ?? CategoryData())
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //let destObject  = tasksVM.uncompletedTasks.value[destinationIndexPath.row-1]
        let movedObject = tasksVM.uncompletedTasks.value[sourceIndexPath.row-1]
        tasksVM.uncompletedTasks.value.remove(at: sourceIndexPath.row-1)
        tasksVM.uncompletedTasks.value.insert(movedObject, at: destinationIndexPath.row-1)
//
//        let items = tasksVM.taskItems.filter { (entity) -> Bool in
//            (entity.id == movedObject.id) || (entity.serverId == movedObject.id)
//        }
//
//        if items.count > 0 {
//            items[0].createdAt = destObject.createdAt
//            PersistenceManager.sharedInstance.mergeWithMainContext()
//        }

    }
    
}
