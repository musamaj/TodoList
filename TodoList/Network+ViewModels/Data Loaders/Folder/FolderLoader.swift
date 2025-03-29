//
//  FolderLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 04/06/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD


let folderLD = FolderLoader.shared


class FolderLoader: NSObject {
    
    
    //MARK:- Properties
    
    
    static var shared          = FolderLoader()
    
    var delegate               : NetworkDelegate?
    var folders                = [FolderData]()
    var folderData             = FolderData()
    
    var selectedIndex          = 0
    
    
    
    // MARK:- Folder Creation
    
    
    func createFolder(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.createFolder, param).timingOut(after: 0) { data in
            
            print("here is folder data \(data)")
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<FolderData>().map(JSON: data) else {
                        self.delegate?.failure(type: .create)
                        return
                    }
                    
                    self.folderData = data
                    self.delegate?.populateData(type: .create)
                    return
                }
            }
            
            self.delegate?.failure(type: .create)
        }
        
    }
    
    
    // MARK:- Fetch Folders
    
    
    func fetchFolders() {
        
        let param = [App.paramKeys.userId : Persistence.shared.currentUserID]
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getFolders, param).timingOut(after: 0) {data in
            
            print("here is folders data \(data)")
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<FolderData>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        return
                    }
                    
                    self.folders = data
                    self.delegate?.populateData(type: .read)
                }
            }
        }
    }
    
    
    // MARK:- Update
    
    
    func updateFolder(param: [String: Any]) {

        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.updateFolder, param).timingOut(after: 0) {data in

            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<FolderData>().map(JSON: data) else {
                        self.delegate?.failure(type: .update)
                        return
                    }

                    self.folderData = data
                    self.delegate?.populateData(type: .update)
                } else {
                    self.delegate?.failure(type: .update)
                }
            } else {
                self.delegate?.failure(type: .update)
            }
        }

    }
    
    
    // MARK:- Delete
    
    
    func deleteFolder(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.deleteFolder, param).timingOut(after: 0) {data in
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let _ = response[App.paramKeys.msg] as? String else {
                        self.delegate?.failure(type: .delete)
                        return
                    }
                    
                    print(data)
                    self.delegate?.populateData(type: .delete)
                    return
                }
            }
            
            self.delegate?.failure(type: .delete)
        }
        
    }
    
    
}


extension FolderLoader {
    
    func createParam(_ folderName: String)-> [String: Any] {
        return [App.paramKeys.name: folderName]
    }
    
    func updateParam(folderId: String)-> [String: Any] {
        return [App.paramKeys.folderId   : folderId as AnyObject]
    }
    
    func deleteParam(id: String)-> [String: Any] {
        return [App.paramKeys.Id   : id]
    }
    
}
