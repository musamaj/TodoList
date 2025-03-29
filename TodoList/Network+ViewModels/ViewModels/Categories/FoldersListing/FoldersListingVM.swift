//
//  FoldersListingVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class FoldersListingVM: NSObject {

    
    // MARK:- Properties
    
    
    static var selectedFolder   : String? {
        didSet {
            if self.selectedFolder != nil {
                FoldersEntity.selectedFolder = nil
            }
        }
    }
    
    var folders                 = Dynamic.init([FolderData]())
    var folderItems             = [FoldersEntity]()
    
    let extraRows               = 2
    
    
    // MARK:- getters
    
    
    func rowsCount()-> Int {
        return self.folders.value.count+extraRows
    }
    
    func getFolder(index: Int)-> FolderData {
        return self.folders.value[index-extraRows]
    }
    
    func getFolderItem(index: Int)-> FoldersEntity {
        return self.folderItems[index-extraRows]
    }
    
    class func getFolderName()-> String {
        return FoldersListingVM.selectedFolder ?? FoldersEntity.selectedFolder?.name ?? App.navTitles.foldersList
    }
    
    
    // MARK:- Functions
    
    
    func createFolder()-> FoldersEntity? {
        
        if let title = FoldersListingVM.selectedFolder {
            let folder = FolderData.initWithParams(title: title)
            FoldersEntity.saveFolder(folder)
            self.syncCreation(folderData: folder, title: title)
            
            return FoldersEntity.selectedFolder
        }

        return FoldersEntity.selectedFolder
    }
    
    
    func fetchFolders() {
        
        self.folderItems = FoldersEntity.getFolders()
        self.folders.value = FolderData().fromNSManagedObject(categories: self.folderItems)
        
        if self.folders.value.isEmpty {
            folderLD.delegate = self
            folderLD.fetchFolders()
        }
        
    }
    
    func syncCreation(folderData: FolderData, title: String) {
        FoldersEntity.fetchId = folderData.id
        var param = folderLD.createParam(title)
        param[App.paramKeys.fetchID] = folderData.id
        
        JobFactory.scheduleJob(param: param, jobType: FolderCreationJob.type, id: folderData.id ?? "")
    }
    
    func handleFetch() {
        self.folders.value = folderLD.folders
        
        PersistenceManager.sharedInstance.deleteAllRecords(entity: FoldersEntity.identifier)
        FoldersEntity.saveFolders(folderLD.folders)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.folderItems = FoldersEntity.getFolders()
        }
    }
    
    
}


// MARK:- Sockets Delegate


extension FoldersListingVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .read {
            self.handleFetch()
        }
    }
    
    func failure(type: responseTypes) {}
}
