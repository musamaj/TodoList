//
//  CategoryUpdateJob.swift
//  TodoList
//
//  Created by Usama Jamil on 08/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class CategoryUpdateJob: Job {
    
    // Type to know which Job to return in job creator
    static let type = "CategoryUpdateJob"
    // Param
    private var tweet: [String: Any]
    
    let categoryLD = CategoryLoader()
    var result     : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.tweet = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            NSCategory.fetchId = self.tweet[App.paramKeys.fetchID] as? String
            self.categoryLD.categoryData.fetchId = self.tweet[App.paramKeys.fetchID] as? String
            
            self.categoryLD.delegate = self
            
            let listId = self.tweet[App.paramKeys.listId] as? String
            NSCategory.fetchId = listId
            let items = NSCategory.getCategories(byPredicate: true)
            
            if items.count > 0 {
                self.tweet[App.paramKeys.listId] = items[0].serverId
            }
            
            self.tweet = FoldersEntity.setFolderId(param: &self.tweet)
            
            self.categoryLD.updateCategory(param: self.tweet)
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
            DispatchQueue.main.async {
                NSCategory.updateByPredicate(self.categoryLD.categoryData)
            }
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


extension CategoryUpdateJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .update {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
