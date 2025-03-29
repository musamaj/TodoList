//
//  SubtaskLoader+Listener.swift
//  TodoList
//
//  Created by Usama Jamil on 10/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


extension SubtaskLoader {
    
    func listeners() {
        
        SocketIOManager.sharedInstance.socket.on(App.Events.subTaskCreated) { (data, ack) in
            print("subttask created data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.subTaskCreated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.subTaskUpdated) { (data, ack) in
            print("subtask updated data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.subTaskUpdated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.subTaskDeleted) { (data, ack) in
            print("subtask deleted is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.subTaskDeleted)
        }
        
    }
    
    func responseHandling(data: [Any], action: String) {
        
        if let controller = UIApplication.topViewController() as? TaskDetailVC {
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.subtask] as? [String: Any] {
                    guard let data = Mapper<SubtaskData>().map(JSON: data) else {
                        Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                    controller.taskDetailVM.listen(data: data, action: action)
                }
            }
        }
    }
    
}





// MARK:- Subtask DB Handlers



extension SubtaskLoader {
    
    class func createSubtask(data: SubtaskData) {
        TaskEntity.fetchId = data.taskId
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            data.parentTask = items[0]
            let _ = SubtaskEntity.saveSubTask(data)
        }
    }
    
    class func updateSubtask(data: SubtaskData) {
        SubtaskEntity.fetchId = data.id
        SubtaskEntity.updateSubtask(data, true)
    }
    
    class func deleteSubtask(data: SubtaskData) {
        SubtaskEntity.fetchId = data.id
        let items = SubtaskEntity.getSubTasks(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}
