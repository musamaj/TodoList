//
//  ChangesManager.swift
//  TodoList
//
//  Created by Usama Jamil on 12/12/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit



enum EntityTypes: String {
    case List
    case Task
    case Subtask
    case Comment
}

enum ActionTypes : String {
    case Create
    case Update
    case Delete
    case Share
    case Unshare
}


class ChangesManager: NSObject {
    
    
    static let shared = ChangesManager()
    
    
    func handleChange(data: GenericData) {
        
        if data.action == ActionTypes.Create.rawValue as String {
            self.performCreate(data: data)
            
        } else if data.action == ActionTypes.Update.rawValue as String {
            self.performUpdate(data: data)
            
        } else if data.action == ActionTypes.Delete.rawValue as String {
            self.performDelete(data: data)
            
        } else if data.action == ActionTypes.Share.rawValue as String {
            self.performCreate(data: data)
            
        } else if data.action == ActionTypes.Unshare.rawValue as String {
            self.performDelete(data: data)            
        }
        
    }
    
    func performCreate(data: GenericData) {
        
        // for share & create, use this one
        
        if data.entityType == EntityTypes.List.rawValue as String {
            self.createCategory(data: data)
            
        } else if data.entityType == EntityTypes.Task.rawValue as String {
            self.createTask(data: data)
            
        } else if data.entityType == EntityTypes.Subtask.rawValue as String {
            self.createSubtask(data: data)
            
        } else if data.entityType == EntityTypes.Comment.rawValue as String {
            self.createComment(data: data)
        }
    }
    
    func performUpdate(data: GenericData) {
        
        if data.entityType == EntityTypes.List.rawValue as String {
            self.updateCategory(data: data)
            
        } else if data.entityType == EntityTypes.Task.rawValue as String {
            self.updateTask(data: data)
            
        } else if data.entityType == EntityTypes.Subtask.rawValue as String {
            self.updateSubtask(data: data)
            
        } else if data.entityType == EntityTypes.Comment.rawValue as String {
            self.updateComment(data: data)
        }
        
    }

    func performDelete(data: GenericData) {
        
        // for unshare & delete, use this one
        
        if data.entityType == EntityTypes.List.rawValue as String {
            self.deleteCategory(data: data)
            
        } else if data.entityType == EntityTypes.Task.rawValue as String {
            self.deleteTask(data: data)
            
        } else if data.entityType == EntityTypes.Subtask.rawValue as String {
            self.deleteSubtask(data: data)
            
        } else if data.entityType == EntityTypes.Comment.rawValue as String {
            self.deleteComment(data: data)
        }
        
    }
    
}



// MARK:- Category DB Handlers



extension ChangesManager {
    
    func createCategory(data: GenericData) {
        let object = CategoryData().fromGenericModel(generic: data.entityData)
        object.accepted = false
        object.createdAt = Utility.getCurrentTimeStamp()
        NSCategory.saveCategory(object, byOWner: true)
        
        let controller = UIApplication.topViewController() as? CategoryListingVC
        //controller?.categoryVM.categories.value.insert(object, at: 0)
        controller?.categoryVM.fetchData()
    }
    
    func updateCategory(data: GenericData) {
        let object = CategoryData().fromGenericModel(generic: data.entityData)
        NSCategory.fetchId = object.id
        NSCategory.updateByPredicate(object)

        let controller = UIApplication.topViewController() as? CategoryListingVC
        controller?.categoryVM.fetchData()
    }
    
    func deleteCategory(data: GenericData) {
        let object = CategoryData().fromGenericModel(generic: data.entityData)
        NSCategory.fetchId = object.id
        let items = NSCategory.getCategories(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }

        let controller = UIApplication.topViewController() as? CategoryListingVC
        controller?.categoryVM.fetchData()
    }
    
}



// MARK:- Task DB Handlers



extension ChangesManager {
    
    func createTask(data: GenericData) {
        NSCategory.fetchId = data.entityData?.listId
        let items = NSCategory.getCategories(byPredicate: true)
        if items.count > 0 {
            let task = TaskData().fromGenericModel(generic: data.entityData)
            task.parentCategory = items[0]
            let _ = TaskEntity.saveTask(task)
        }
    }
    
    func updateTask(data: GenericData) {
        let task = TaskData().fromGenericModel(generic: data.entityData)
        TaskEntity.fetchId = task.id
        TaskEntity.updateTask(task, true)
    }
    
    func deleteTask(data: GenericData) {
        let task = TaskData().fromGenericModel(generic: data.entityData)
        TaskEntity.fetchId = task.id
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}



// MARK:- Subtask DB Handlers



extension ChangesManager {
    
    func createSubtask(data: GenericData) {
        TaskEntity.fetchId = data.entityData?.taskId
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            let task = SubtaskData().fromGenericModel(generic: data.entityData)
            task.parentTask = items[0]
            let _ = SubtaskEntity.saveSubTask(task)
        }
    }
    
    func updateSubtask(data: GenericData) {
        let task = SubtaskData().fromGenericModel(generic: data.entityData)
        SubtaskEntity.fetchId = task.id
        SubtaskEntity.updateSubtask(task, true)
    }
    
    func deleteSubtask(data: GenericData) {
        let task = SubtaskData().fromGenericModel(generic: data.entityData)
        SubtaskEntity.fetchId = task.id
        let items = SubtaskEntity.getSubTasks(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}



// MARK:- Comment DB Handlers



extension ChangesManager {
    
    func createComment(data: GenericData) {
        TaskEntity.fetchId = data.entityData?.taskId
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            let comment = CommentData().fromGenericModel(generic: data.entityData)
            comment.parentTask = items[0]
            let _ = CommentEntity.saveComment(comment, byOWner: true)
        }
    }
    
    func updateComment(data: GenericData) {
        let comment = CommentData().fromGenericModel(generic: data.entityData)
        CommentEntity.fetchId = comment.id
        CommentEntity.updateComment(comment, true)
    }
    
    func deleteComment(data: GenericData) {
        let comment = CommentData().fromGenericModel(generic: data.entityData)
        CommentEntity.fetchId = comment.id
        let items = CommentEntity.getComments(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}
