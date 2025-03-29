//
//  InvitationsLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 23/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import ObjectMapper
import SVProgressHUD


let inviteLD = InvitationsLoader.shared


class InvitationsLoader: NSObject {
    
    
    // MARK:- Properties
    
    
    static var shared           = InvitationsLoader()
    var delegate                : NetworkDelegate?
    var categoryUsers           = [RegisterUser]()
    var userData                = RegisterUser()
    
    fileprivate let manager     = NetworkManager()
    
    
    
    func unshareParam(userId: String)-> [String: Any] {
        return [ App.paramKeys.userId : userId,
                 App.paramKeys.listId : TasksListVM.selectedCategory?.id as Any]
    }
    
    
    // MARK:- Invite Member
    
    
    func invite(param: [String: AnyObject]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.shareAList, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let user = response[App.paramKeys.data] as? [String : Any] {
                    
                    guard let data = Mapper<RegisterUser>().map(JSON: user) else {
                        self.delegate?.failure(type: .share)
                        return
                    }
                    
                    self.userData = data
                    self.delegate?.populateData(type: .share)
                    
                } else {
                    self.delegate?.failure(type: .share)
                }
            } else {
                self.delegate?.failure(type: .share)
            }
        }
        
        self.delegate?.failure(type: .share)
    }
    
    // MARK:- List Shared Users
    
    
    func fetchUsers() {
    
        let param = [App.paramKeys.listId : TasksListVM.selectedCategory?.id]
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getListUsers, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<RegisterUser>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    self.categoryUsers = data
                    self.delegate?.populateData(type: .users)
                }
            }
        }
    }
    
    
    // MARK:- Unshare List
    
    
    func unshare(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.unshareAList, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    
                    guard let data = Mapper<RegisterUser>().map(JSON: response) else {
                        self.delegate?.failure(type: .unshare)
                        return
                    }
                    
                    self.userData = data
                    self.delegate?.populateData(type: .unshare)
                    return
                }
            }
            
            self.delegate?.failure(type: .unshare)
        }
    }

}
