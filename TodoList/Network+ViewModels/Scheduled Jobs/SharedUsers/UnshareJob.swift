//
//  UnshareJob.swift
//  TodoList
//
//  Created by Usama Jamil on 22/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class UnshareJob: Job {
    
    // Type to know which Job to return in job creator
    static let type     = "UnshareJob"
    // Param
    private var param   : [String: Any]
    
    let inviteLD        = InvitationsLoader()
    var result          : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.param = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            SharedUsersEntity.fetchId = self.param[App.paramKeys.fetchID] as? String
            
            self.inviteLD.delegate = self
            
            let listId = self.param[App.paramKeys.listId] as? String
            NSCategory.fetchId = listId
            let items = NSCategory.getCategories(byPredicate: true)
            
            if items.count > 0 {
                self.param[App.paramKeys.listId] = items[0].serverId
            }
            
            let userId = self.param[App.paramKeys.userId] as? String
            SharedUsersEntity.fetchId = userId
            let userItems = SharedUsersEntity.getUsers(byPredicate: true)
            
            if userItems.count > 0 {
                self.param[App.paramKeys.userId] = userItems[0].serverId
            }
            
            self.inviteLD.unshare(param: self.param)
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
            break
            
        case .fail(let error):
            // Job fail
            print(error.localizedDescription)
            break
        }
    }
    
}


// MARK:- Sockets Delegate


extension UnshareJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .unshare {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
