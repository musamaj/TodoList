//
//  CategoryApprovalJob.swift
//  TodoList
//
//  Created by Usama Jamil on 12/02/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class CategoryApprovalJob: Job {
    
    // Type to know which Job to return in job creator
    static let type = "CategoryApprovalJob"
    // Param
    private var param: [String: Any]
    
    let categoryLD = CategoryLoader()
    var result     : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.param = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            NSCategory.fetchId = self.param[App.paramKeys.fetchID] as? String
            self.categoryLD.categoryData.fetchId = self.param[App.paramKeys.fetchID] as? String
            
            self.categoryLD.delegate = self
            
            let listId = self.param[App.paramKeys.listId] as? String
            NSCategory.fetchId = listId
            let items = NSCategory.getCategories(byPredicate: true)
            
            if items.count > 0 {
                self.param[App.paramKeys.listId] = items[0].serverId
            }
            
            self.categoryLD.approveCategory(param: self.param)
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
            // Job success
            break
            
        case .fail(let error):
            // Job fail
            print(error.localizedDescription)
            break
            
        }
    }
    
    func onSuccess() {
        
    }
}


// MARK:- Sockets Delegate


extension CategoryApprovalJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .approve {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
