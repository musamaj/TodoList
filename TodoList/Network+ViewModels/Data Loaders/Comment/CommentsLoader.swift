//
//  CommentsLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 08/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD


let commentLD = CommentsLoader.shared


class CommentsLoader: NSObject {

    
    static var shared             = CommentsLoader()
    
    var delegate                  : NetworkDelegate?
    var comments                  = [CommentData]()
    var commentData               = CommentData()
    
    
    
    // MARK:- add Comment
    
    
    func comment(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.createComment, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<CommentData>().map(JSON: data) else {
                        self.delegate?.failure(type: .commentCreate)
                        return
                    }
                    
                    self.commentData = data
                    self.delegate?.populateData(type: .commentCreate)
                    return
                }
            }
            
            self.delegate?.failure(type: .commentCreate)
        }
        
    }
    
    
    // MARK:- fetch subtasks
    
    
    func fetchComments() {
        
        let param = [App.paramKeys.taskId :TaskDetailVM.selectedTask?.id]
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getComments, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<CommentData>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    self.comments = data
                    self.delegate?.populateData(type: .commentRead)
                }
            }
        }
    }
    
    
    // MARK:- delete Comment
    
    
    func deleteComment(param: [String: Any]) {
                
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.deleteComment, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let msg = response[App.paramKeys.msg] as? String else {
                        self.delegate?.failure(type: .commentDelete)
                        return
                    }
                    
                    print(msg)
                    self.delegate?.populateData(type: .commentDelete)
                }
            }
            
            self.delegate?.failure(type: .commentDelete)
        }
    }
    
}



extension CommentsLoader {
    
    func createParam(params: [String: AnyObject])-> [String: Any] {
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.body   : params as AnyObject]
    }
    
    func updateParam(subtaskId: String, params: [String: AnyObject])-> [String: Any] {
        
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.subtaskId : subtaskId as AnyObject,
                App.paramKeys.body   : params as AnyObject]
    }
    
    func deleteParam(commentId: String)-> [String: Any] {
        return [App.paramKeys.taskId : TaskDetailVM.selectedTask?.id as AnyObject,
                App.paramKeys.commentId : commentId as AnyObject]
    }
    
}
