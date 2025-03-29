//
//  FolderUpdateJob.swift
//  TodoList
//
//  Created by Usama Jamil on 08/06/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class FolderUpdateJob: Job {
    
    // Type to know which Job to return in job creator
    static let type = "FolderUpdateJob"
    // Param
    private var param: [String: Any]
    
    let folderLD   = FolderLoader()
    var result     : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.param = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            FoldersEntity.fetchId = self.param[App.paramKeys.fetchID] as? String
            
            self.param = FoldersEntity.setFolderId(param: &self.param)
            
            self.folderLD.delegate = self
            self.folderLD.updateFolder(param: self.param)
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
                FoldersEntity.updateByPredicate(self.folderLD.folderData)
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


extension FolderUpdateJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .create {
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
