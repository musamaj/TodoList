//
//  CommentCreationJob.swift
//  TodoList
//
//  Created by Usama Jamil on 11/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class CommentCreationJob: Job {
    
    // Type to know which Job to return in job creator
    static let type     = "CommentCreationJob"
    // Param
    private var param   : [String: Any]
    
    let commentLD       = CommentsLoader()
    var result          : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.param = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            CommentEntity.fetchId = self.param[App.paramKeys.fetchID] as? String
            
            self.commentLD.delegate = self
            
            let taskId = self.param[App.paramKeys.taskId] as? String
            TaskEntity.fetchId = taskId
            let items = TaskEntity.getTasks(byPredicate: true)
            
            if items.count > 0 {
                self.param[App.paramKeys.taskId] = items[0].serverId
            }
            
            self.commentLD.comment(param: self.param)
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
            DispatchQueue.main.async {
                CommentEntity.updateComment(self.commentLD.commentData, true)
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


extension CommentCreationJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .commentCreate {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
