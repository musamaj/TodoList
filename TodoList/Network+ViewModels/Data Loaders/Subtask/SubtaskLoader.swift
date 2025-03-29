//
//  SubtaskLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 01/10/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


let subTaskLD = SubtaskLoader.shared


class SubtaskLoader: NSObject {
    
    
    static var shared             = SubtaskLoader()
    
    var delegate                  : NetworkDelegate?
    var subtasks                  = [SubtaskData]()
    var subtaskData               = SubtaskData()
    
    
    // MARK:- add Subtask
    
    
    func addSubtask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.createSubtask, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<SubtaskData>().map(JSON: data) else {
                        self.delegate?.failure(type: .subtaskCreate)
                        return
                    }
                    
                    self.subtaskData = data
                    self.delegate?.populateData(type: .subtaskCreate)
                    return
                }
            }
            
            self.delegate?.failure(type: .subtaskCreate)
        }
        
    }
    
    
    // MARK:- update Subtask
    
    
    func updateSubtask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.updateSubtask, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<SubtaskData>().map(JSON: data) else {
                        self.delegate?.failure(type: .subtaskUpdate)
                        return
                    }
                    
                    self.subtaskData = data
                    self.delegate?.populateData(type: .subtaskUpdate)
                    return
                }
            }
            
            self.delegate?.failure(type: .subtaskUpdate)
        }
    }
    
    
    // MARK:- fetch subtasks
    
    
    func fetchSubtasks() {
        
        let param = [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id]
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getSubtasks, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<SubtaskData>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    self.subtasks = data
                    self.delegate?.populateData(type: .subtaskRead)
                }
            }
        }
        
    }
    
    
    // MARK:- delete Subtask
    
    
    func deleteSubtask(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.deleteSubtask, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let _ = response[App.paramKeys.msg] as? String else {
                        self.delegate?.failure(type: .subtaskDelete)
                        return
                    }
                    
                    self.delegate?.populateData(type: .subtaskDelete)
                    return
                }
            }
            
            self.delegate?.failure(type: .subtaskDelete)
        }
    }

}


extension SubtaskLoader {
    
    func createParam(params: [String: AnyObject])-> [String: Any] {
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.body   : params as AnyObject]
    }
    
    func updateParam(subtaskId: String, params: [String: AnyObject])-> [String: Any] {
        
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.subtaskId : subtaskId as AnyObject,
                App.paramKeys.body   : params as AnyObject]
    }
    
    func deleteParam(subtaskId: String)-> [String: Any] {
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.subtaskId : subtaskId as AnyObject]
    }
    
}
