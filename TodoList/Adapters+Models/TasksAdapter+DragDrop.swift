//
//  TasksAdapter+Drag.swift
//  TodoList
//
//  Created by Usama Jamil on 26/02/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


extension TasksAdapter {
    
    func configureDragDrop() {
        
        if #available(iOS 11.0, *) {
            tasksTableView.dragDelegate = self
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            tasksTableView.dropDelegate = self
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            tasksTableView.dragInteractionEnabled = true
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
}


extension TasksAdapter: UITableViewDragDelegate {
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            return [UIDragItem]() // Prevents dragging item from 0th index
        }
        return self.dragItems(for: indexPath)
    }
    
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            return [UIDragItem]() // Prevents dragging item from 0th index
        }
        return self.dragItems(for: indexPath)
    }
    
    @available(iOS 11.0, *)
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        
        var dataType = kUTTypePlainText
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            dataType = kUTTypeData
        }
        
        var taskData = TaskData()
        taskData.descriptionField = App.placeholders.dueTomorrow
        
        if (indexPath.row > 0 && indexPath.section == 0) || indexPath.section == 1 {
            taskData = indexPath.section == 0 ? tasksVM.uncompletedTasks.value[indexPath.row-1] : tasksVM.completedTasks.value[indexPath.row]
        }
        
        let data = taskData.descriptionField?.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: dataType as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
}



extension TasksAdapter: UITableViewDropDelegate {
    
    @available(iOS 11.0, *)
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: String.self)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return self.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if (destinationIndexPath?.section == 0 && destinationIndexPath?.row == 0) || destinationIndexPath?.section == 1 {
            return UITableViewDropProposal(operation: .forbidden, intent: .insertIntoDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // Handles Drop
    }
    
}
