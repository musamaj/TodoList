//
//  TaskDeletionJob.swift
//  TodoList
//
//  Created by Usama Jamil on 08/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class TaskDeletionJob: Job {
    
    // Type to know which Job to return in job creator
    static let type     = "TaskDeletionJob"
    // Param
    private var param   : [String: Any]
    
    let taskLD          = TaskLoader()
    var result          : JobResult?
    
    var items           = [TaskEntity]()
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.param = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            
            TaskEntity.fetchId = self.param[App.paramKeys.fetchID] as? String
            
            self.taskLD.delegate = self
            
            let listId = self.param[App.paramKeys.listId] as? String
            NSCategory.fetchId = listId
            let items = NSCategory.getCategories(byPredicate: true)
            
            if items.count > 0 {
                self.param[App.paramKeys.listId] = items[0].serverId
            }
            
            let taskId = self.param[App.paramKeys.taskId] as? String
            TaskEntity.fetchId = taskId
            let taskItems = TaskEntity.getTasks(byPredicate: true)
            self.items    = taskItems
            
            if taskItems.count > 0 {
                self.param[App.paramKeys.taskId] = taskItems[0].serverId
            }
            
            self.taskLD.deleteTask(param: self.param)
            self.result = callback
        }
    }
    
    func onRetry(error: Error) -> RetryConstraint {
        // Check if error is non fatal
        return RetryConstraint.retry(delay: 0) // immediate retry
    }
    
    func onRemove(result: JobCompletion) {
        // This job will never run anymore
        switch result {
        case .success:
//            let tasks = TaskEntity.getTasks(byPredicate: true)
            if items.count > 0 {
                //TaskEntity.deleteTask(items[0])
            }

            break
            
        case .fail(let error):
            // Job fail
            print(error.localizedDescription)
            break
            
        }
    }
    
}


// MARK:- Sockets Delegate


extension TaskDeletionJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .delete {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
