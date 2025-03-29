//
//  TaskCreationPendingJob.swift
//  TodoList
//
//  Created by Usama Jamil on 06/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class TaskCreationJob: Job {
    
    // Type to know which Job to return in job creator
    static let type     = "TaskCreationJob"
    // Param
    private var param   : [String: Any]
    
    let taskLD          = TaskLoader()
    var result          : JobResult?
    
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
            
            self.taskLD.createTask(param: self.param)
            self.result = callback
        }
    }
    
    func onRetry(error: Error) -> RetryConstraint {
        // Check if error is non fatal
        return RetryConstraint.retry(delay: 5) // immediate retry
    }
    
    func onRemove(result: JobCompletion) {
        // This job will never run anymore
        switch result {
        case .success:
            DispatchQueue.main.async {
                TaskEntity.updateTask(self.taskLD.taskData, true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                if let controller = UIApplication.topViewController() as? TaskListingVC {
                    controller.tasksVM.fetchData()
                }
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


extension TaskCreationJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .create {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
