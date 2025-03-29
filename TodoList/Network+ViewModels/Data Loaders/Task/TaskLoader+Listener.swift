//
//  TaskLoader+Listener.swift
//  TodoList
//
//  Created by Usama Jamil on 06/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


extension TaskLoader {
    
    func listeners() {
        
        SocketIOManager.sharedInstance.socket.on(App.Events.taskCreated) { (data, ack) in
            print("task created data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.taskCreated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.taskUpdated) { (data, ack) in
            print("task updated data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.taskUpdated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.taskDeleted) { (data, ack) in
            print("task deleted is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.taskDeleted)
        }
        
    }
    
    func responseHandling(data: [Any], action: String) {
        
        if let controller = UIApplication.topViewController() as? TaskListingVC {
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<TaskData>().map(JSON: response) else {
                        Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                    controller.tasksVM.listen(data: data, action: action)
                }
            }
            
        } else if let controller = UIApplication.topViewController() as? TaskDetailVC {
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<TaskData>().map(JSON: response) else {
                        Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    controller.taskDetailVM.listen(data: data, action: action)
                }
            }
        }
    }
    
}



// MARK:- Task DB Handlers



extension TaskLoader {
    
    class func createTask(data: TaskData) {
        NSCategory.fetchId = data.listId
        let items = NSCategory.getCategories(byPredicate: true)
        if items.count > 0 {
            data.parentCategory = items[0]
            let _ = TaskEntity.saveTask(data)
        }
    }
    
    class func updateTask(data: TaskData) {
        TaskEntity.fetchId = data.id
        TaskEntity.updateTask(data, true)
    }
    
    class func deleteTask(data: TaskData) {
        TaskEntity.fetchId = data.id
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}
