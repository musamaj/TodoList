//
//  ShareJob.swift
//  TodoList
//
//  Created by Usama Jamil on 22/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue
import UIKit

// A job to send a tweet
class ShareJob: Job {
    
    // Type to know which Job to return in job creator
    static let type     = "ShareJob"
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
            
            self.inviteLD.invite(param: self.param as [String : AnyObject])
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
            self.completionHandler()
            break
            
        case .fail(let error):
            // Job fail
            self.completionHandler()
            print(error.localizedDescription)
            break
            
        }
    }
    
    func completionHandler() {
        DispatchQueue.main.async {
            
            let users = SharedUsersEntity.getUsers(false, sortAscending: false, byPredicate: true)
            
            if let _ = self.inviteLD.userData.id {
                if users.count > 0 {
                    SharedUsersEntity.selectedUser = users[0]
                    SharedUsersEntity.updateUser(self.inviteLD.userData)
                    
                }
            } else {
                if users.count > 0 {
                    SharedUsersEntity.deleteUser(users[0])
                }
            }
            
            let viewController = UIApplication.topViewController() as? CategoryCreationVC
            viewController?.categoryVM.fetchUsers()
        }

    }
    
}


// MARK:- Sockets Delegate


extension ShareJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .share {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
