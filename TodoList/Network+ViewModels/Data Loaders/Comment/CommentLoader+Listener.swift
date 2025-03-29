//
//  CommentLoader+Listener.swift
//  TodoList
//
//  Created by Usama Jamil on 11/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


extension CommentsLoader {
    
    func listeners() {
        
        SocketIOManager.sharedInstance.socket.on(App.Events.commentCreated) { (data, ack) in
            print("comment  created data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.commentCreated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.commentUpdated) { (data, ack) in
            print("comment updated data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.commentUpdated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.commentDeleted) { (data, ack) in
            print("comment deleted is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.commentDeleted)
        }
        
    }
    
    func responseHandling(data: [Any], action: String) {
        
        if let controller = UIApplication.topViewController() as? TaskDetailVC {
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.commentStr] as? [String: Any] {
                    guard let data = Mapper<CommentData>().map(JSON: data) else {
                        Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                    controller.taskDetailVM.listen(data: data, action: action)
                }
            }
        }
    }
    
}





// MARK:- Comment DB Handlers



extension CommentsLoader {
    
    class func createComment(data: CommentData) {
        TaskEntity.fetchId = data.taskId
        let items = TaskEntity.getTasks(byPredicate: true)
        if items.count > 0 {
            data.parentTask = items[0]
            let _ = CommentEntity.saveComment(data, byOWner: true)
        }
    }
    
    class func updateComment(data: CommentData) {
        CommentEntity.fetchId = data.id
        CommentEntity.updateComment(data, true)
    }
    
    class func deleteComment(data: CommentData) {
        CommentEntity.fetchId = data.id
        let items = CommentEntity.getComments(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}
