//
//  TaskLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 06/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD


let taskLD = TaskLoader.shared


class TaskLoader: NSObject {
    
    
    //MARK:- Properties
    
    
    static var shared          = TaskLoader()
    
    var delegate               : NetworkDelegate?
    var tasks                  = [TaskData]()
    var taskData               = TaskData()
    
    var selectedIndex          = 0
    
    
    
    // MARK:- TASK Creation
    
   
    func createTask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.createTask, param).timingOut(after: 0) { data in
            
            print("here is task data \(data)")
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<TaskData>().map(JSON: data) else {
                        self.delegate?.failure(type: .create)
                        return
                    }
                    
                    self.taskData = data
                    self.delegate?.populateData(type: .create)
                    return
                }
            }
            
            self.delegate?.failure(type: .create)
        }
        
    }
    
    
    // MARK:- Fetch
    
    
    func fetchTasks(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getTasks, param).timingOut(after: 0) {data in
            
            print("here is tasks data \(data)")
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<TaskData>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    self.tasks = data.reversed()
                    self.delegate?.populateData(type: .read)
                }
            }
        }
    }
    
    
    // MARK:- Update
    
    
    func updateTask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.updateTask, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<TaskData>().map(JSON: data) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        self.delegate?.failure(type: .update)
                        return
                    }
                    
                    self.taskData = data
                    self.delegate?.populateData(type: .update)
                } else {
                    self.delegate?.failure(type: .update)
                    print("here")
                }
            } else {
                self.delegate?.failure(type: .update)
            }
        }
        
    }
    
    
    // MARK:- Delete
    
    
    func deleteTask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.deleteTask, param).timingOut(after: 0) {data in
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let _ = response[App.paramKeys.msg] as? String else {
                        self.delegate?.failure(type: .delete)
                        return
                    }
                    
                    print(data)
                    self.delegate?.populateData(type: .delete)
                    return
                }
            }
            
            self.delegate?.failure(type: .delete)
        }
        
    }

    
}


extension TaskLoader {
    
    func fetchParam()-> [String: Any] {
        return [App.paramKeys.listId : TasksListVM.selectedCategory?.id ?? ""]
    }
    
    func createParam(_ taskName: String)-> [String: Any] {
        return [App.paramKeys.listId : TasksListVM.selectedCategory?.id ?? "",
                App.paramKeys.desc: taskName]
    }
    
    func updateParam(taskId: String, check: Bool)-> [String: Any] {
        let params = [App.paramKeys.done: check]
        
        let param = [App.paramKeys.listId   : TasksListVM.selectedCategory?.id as AnyObject,
                     App.paramKeys.taskId   : taskId as AnyObject,
                     App.paramKeys.body     : params as AnyObject
        ]
        
        return param
    }
    
    func deleteParam(id: String)-> [String: Any] {
        return [App.paramKeys.listId   : TasksListVM.selectedCategory?.id ?? "",
                     App.paramKeys.taskId   : id]
    }
    
}
