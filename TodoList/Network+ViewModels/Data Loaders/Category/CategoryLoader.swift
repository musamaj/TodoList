//
//  CategoryLoader.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD


enum responseTypes: String {
    
    case create
    case read
    case update
    case delete
    case approve
    
    case users
    case share
    case unshare
    
    case commentCreate
    case commentUpdate
    case commentRead
    case commentDelete
    
    case subtaskCreate
    case subtaskUpdate
    case subtaskRead
    case subtaskDelete
    
    case changeStream
}


protocol NetworkDelegate: class
{
    func populateData(type: responseTypes)
    func failure(type: responseTypes)
}


let categoryLD = CategoryLoader.shared


class CategoryLoader: NSObject {
    
    
    //MARK:- Properties
    
    
    static var shared               = CategoryLoader()
    
    var delegate                    : NetworkDelegate?
    var categories                  = [CategoryData]()
    var categoryData                = CategoryData()
    var categoryUsers               = [RegisterUser]()
    var changesData                 = [GenericData]()
    
    
    //MARK:- Fetching
    
    func setLastTimeStamp(data: [GenericData]?) {
        
        if let changeStream = data {
            self.changesData = changeStream
            if changeStream.count > 0 {
                Persistence.shared.refreshToken = changeStream[changeStream.count-1].createdAt  ?? Persistence.shared.refreshToken
            }
        }
    }
    
    func fetchChanges(_ firstTime: Bool = false) {
                
        Auth().fetchChangeStreams(successBlock: { [weak self] (data) in
            
            self?.setLastTimeStamp(data: data)
            
            if firstTime {
                self?.changesData.removeAll()
            }
            self?.delegate?.populateData(type: .changeStream)
            print(data as Any)
            
        }) { (error) in
            self.delegate?.failure(type: .changeStream)
        }
        
    }
    
    
    func fetchCategories() {
        
        let param = [App.paramKeys.userId : Persistence.shared.currentUserID]
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getLists, param).timingOut(after: 0) {data in
                        
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<CategoryData>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    self.categories = data.reversed()
                    self.delegate?.populateData(type: .read)
                }
            }
        }
    }
    
    
    //MARK:- Deletion
    
    func deleteParam(data: CategoryData)-> [String: Any] {
        return [App.paramKeys.Id : Persistence.shared.currentUserID,
                App.paramKeys.listId : data.id ?? ""]
    }
    
    func deleteCategory(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.deleteList, param).timingOut(after: 0) {data in
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let _ = response[App.paramKeys.msg] as? String else {
                        self.delegate?.failure(type: .delete)
                        return
                    }
                    
                    self.delegate?.populateData(type: .delete)
                    return
                }
            }
            
            self.delegate?.failure(type: .delete)
        }
    }
    
    
    //MARK:- Creation
    
    
    func createCategory(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.createList, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<CategoryData>().map(JSON: data) else {
                        self.delegate?.failure(type: .create)
                        return
                    }
                    
                    self.categoryData = data
                    self.delegate?.populateData(type: .create)
                    return
                }
            }
            
            self.delegate?.failure(type: .create)
        }
    }
    
    
    //MARK:- List Approval
    
    
    func approveCategory(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.approveList, param).timingOut(after: 0) {data in
            print(data)
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<CategoryData>().map(JSON: data) else {
                        self.delegate?.failure(type: .approve)
                        return
                    }
                    
                    self.categoryData = data
                    self.delegate?.populateData(type: .approve)
                    return
                }
            }
            
            self.delegate?.failure(type: .update)
        }
    }

    
    
    //MARK:- Update
    
    
    func updateCategory(param: [String: Any]) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.updateList, param).timingOut(after: 0) {data in
            print(data)
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any], let data = response[App.paramKeys.data] as? [String: Any] {
                    guard let data = Mapper<CategoryData>().map(JSON: data) else {
                        self.delegate?.failure(type: .update)
                        return
                    }
                    
                    self.categoryData = data
                    self.delegate?.populateData(type: .update)
                    return
                }
            }
            
            self.delegate?.failure(type: .update)
        }
    }
    
}

