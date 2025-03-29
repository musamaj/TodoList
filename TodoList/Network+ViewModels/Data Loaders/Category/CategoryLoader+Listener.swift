//
//  CategoryLoader+Listener.swift
//  TodoList
//
//  Created by Usama Jamil on 23/10/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import ObjectMapper


extension CategoryLoader {
    
    
    func listeners() {
        
        SocketIOManager.sharedInstance.socket.on(App.Events.listShared) { (data, ack) in
            print("list shared data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.listShared)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.listUnshared) { (data, ack) in
            print("list unshared data is: \(data)")
    
            self.responseHandling(data: data, action: App.Events.listUnshared)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.listUpdated) { (data, ack) in
            print("list update data is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.listUpdated)
        }
        
        SocketIOManager.sharedInstance.socket.on(App.Events.listDeleted) { (data, ack) in
            print("list deleted is: \(data)")
            
            self.responseHandling(data: data, action: App.Events.listDeleted)
        }
        
    }
    
    
    func joinList(listId: String) {
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.joinAList, [App.paramKeys.listId: listId]).timingOut(after: 0) {data in
            print("list join data is: \(data)")
        }
    }
    
}



 // MARK:- Response Handling



extension CategoryLoader {
    
    func responseHandling(data: [Any], action: String) {
        
        if data.count > 0 {
            if let response = data[0] as? [String: Any] {
                guard let data = Mapper<CategoryData>().map(JSON: response) else {
                    Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                    return
                }
                
                if action == App.Events.listUnshared {
                    
                    if let controller = UIApplication.topViewController() as? CategoryListingVC {
                        Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                        self.deleteCategory(data: data)
                        controller.categoryVM.fetchData()
                        
                    } else if let _ = UIApplication.topViewController() as? AccountDetailsVC {
                        Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                        self.deleteCategory(data: data)
                        
                    } else if data.id == TasksListVM.selectedCategory?.id && Persistence.shared.isUserAlreadyLoggedIn {
                        Utility.deleteCallBack = {
                            Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                            UIApplication.topViewController()?.popToHome()
                            self.deleteCategory(data: data)
                        }
                        Utility.showWarning()
                    }
                    
                } else if let controller = UIApplication.topViewController() as? CategoryListingVC {
                    
                    if action == App.Events.listShared {
                        controller.categoryVM.categories.value.insert(data, at: 0)
                        self.joinList(listId: data.id ?? "")
                        self.createCategory(data: data)                        
                        controller.categoryVM.fetchData()
                        
                        controller.categoryVM.fetchData()
                        
                    } else if action == App.Events.listDeleted {
                        controller.categoryVM.Delete(data: data)
                        self.deleteCategory(data: data)
                        
                    } else if action == App.Events.listUpdated {
                        controller.categoryVM.Update(data: data)
                        self.updateCategory(data: data)
                    }
                    
                    Persistence.shared.refreshToken = data.changeStreamCreatedAt ?? Persistence.shared.refreshToken
                    
                } else if let _ = UIApplication.topViewController() as? TaskListingVC {
                    //controller.tasksVM.update(data: data)
                }
            }
        }
    }
    
}





// MARK:- Category DB Handlers



extension CategoryLoader {
    
    func createCategory(data: CategoryData) {
        data.accepted = false
        data.createdAt = Utility.getCurrentTimeStamp()
        NSCategory.saveCategory(data, byOWner: true)
    }
    
    func updateCategory(data: CategoryData) {
        NSCategory.fetchId = data.id
        NSCategory.updateByPredicate(data)
    }
    
    func deleteCategory(data: CategoryData) {
        NSCategory.fetchId = data.id
        let items = NSCategory.getCategories(byPredicate: true)
        if items.count > 0 {
            items[0].rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
    }
    
}
