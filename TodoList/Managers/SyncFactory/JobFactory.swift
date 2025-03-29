//
//  JobFactory.swift
//  TodoList
//
//  Created by Usama Jamil on 06/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue


class JobFactory: JobCreator {
    
    static var queueManager : SwiftQueueManager?//Builder(creator: JobFactory()).build()
    
    
    class func setManager() {
        
        if JobFactory.queueManager == nil {
            JobFactory.queueManager = SwiftQueueManagerBuilder(creator: JobFactory()).build()
        }
    }
    
    // Base on type, return the actual job implementation
    func create(type: String, params: [String: Any]?) -> Job {
    
        // check for job and params type
        
        if type == CategoryCreationJob.type  {
            return CategoryCreationJob(params: params ?? [:])
            
        } else if type == CategoryUpdateJob.type {
            return CategoryUpdateJob(params: params ?? [:])
            
        } else if type == CategoryApprovalJob.type {
            return CategoryApprovalJob(params: params ?? [:])
            
        } else if type == CategoryDeletionJob.type {
            return CategoryDeletionJob(params: params ?? [:])
            
        } else if type == TaskCreationJob.type {
            return TaskCreationJob(params: params ?? [:])
            
        } else if type == TaskUpdateJob.type {
            return TaskUpdateJob(params: params ?? [:])
            
        } else if type == TaskDeletionJob.type {
            return TaskDeletionJob(params: params ?? [:])
            
        } else if type == SubtaskCreationJob.type {
            return SubtaskCreationJob(params: params ?? [:])
            
        } else if type == SubtaskUpdateJob.type {
            return SubtaskUpdateJob(params: params ?? [:])
            
        } else if type == SubtaskDeletionJob.type {
            return SubtaskDeletionJob(params: params ?? [:])
            
        } else if type == CommentCreationJob.type {
            return CommentCreationJob(params: params ?? [:])
            
        } else if type == CommentDeletionJob.type {
            return CommentDeletionJob(params: params ?? [:])
            
        } else if type == ShareJob.type {
            return ShareJob(params: params ?? [:])
            
        } else if type == UnshareJob.type {
            return UnshareJob(params: params ?? [:])
            
        } else if type == FolderCreationJob.type {
            return FolderCreationJob(params: params ?? [:])
            
        } else if type == FolderUpdateJob.type {
            return FolderUpdateJob(params: params ?? [:])
            
        } else {
            // Nothing match
            // You can use `fatalError` or create an empty job to report this issue.
            fatalError("No Job !")
        }
    }
    
    static func scheduleJob(param: [String: Any], jobType: String, id: String, delay: TimeInterval = 0.0) {
        
        if let _ = JobFactory.queueManager {
            JobBuilder(type: jobType)
                // Prevent adding the same job multiple times
                //.singleInstance(forId: id)
                // Requires internet to run
                .internet(atLeast: .cellular)
                // persist job
                .persist(required: true)
                // params of my job
                .with(params: param)
                .delay(time: delay)
                // No retry by default
                //.retry(limit: .limited(3))
                // Qos
                //.service(quality: .userInteractive)
                // Priority
                //.priority(priority: .high)
                // Add to queue manager
                .schedule(manager: JobFactory.queueManager!)
        }
        
    }
}
