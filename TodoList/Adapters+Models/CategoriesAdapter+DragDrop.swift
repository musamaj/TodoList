//
//  CategoriesAdapter+DragDrop.swift
//  TodoList
//
//  Created by Usama Jamil on 28/04/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


extension CategoriesAdapter {
    
    func configureDragDrop() {
        
        if #available(iOS 11.0, *) {
            categoriesTableView.dragDelegate = self
            categoriesTableView.dropDelegate = self
            categoriesTableView.dragInteractionEnabled = true
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
}


extension CategoriesAdapter: UITableViewDragDelegate {
    
    @available(iOS 11.0, *)
    func getDragItems(indexPath: IndexPath)-> [UIDragItem] {
        if indexPath.section == viewModel.folderKeys.count {
            return [UIDragItem]() // Prevents dragging item
        }
        return self.dragItems(for: indexPath)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return self.getDragItems(indexPath: indexPath)
    }
    
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return self.getDragItems(indexPath: indexPath)
    }
    
    @available(iOS 11.0, *)
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        
        var dataType = kUTTypePlainText
        if indexPath.section == viewModel.folderKeys.count {
            dataType = kUTTypeData // will not allow to drop this item due to data type
        }
        
        let taskData = TaskData() // dummy data passed for now
        taskData.descriptionField = App.placeholders.dueTomorrow
        
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



extension CategoriesAdapter: UITableViewDropDelegate {
    
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
        
        if destinationIndexPath?.section == viewModel.folderKeys.count {
            return UITableViewDropProposal(operation: .forbidden, intent: .insertIntoDestinationIndexPath)
            
        }
//        else if let indexP = destinationIndexPath {
//            
//            if (viewModel.categoryByFolders[viewModel.folderKeys[indexP.section]]?.count ?? 0) > 0 && viewModel.folderKeys[indexP.section] == viewModel.categoryByFolders[viewModel.folderKeys[indexP.section]]?[0].parentFolder?.id && indexP.row == 0 {
//                return UITableViewDropProposal(operation: .forbidden, intent: .insertIntoDestinationIndexPath)
//            }
//            
//        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // Handles Drop
        
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [String]

            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                //self.model.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
        viewModel.fetchData()
        
    }
    
}
