//
//  FoldersEntity+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 22/04/2020.
//
//

import Foundation
import CoreData

@objc(FoldersEntity)
public class FoldersEntity: NSManagedObject {

    
    static var selectedFolder          : FoldersEntity? {
        didSet {
            if self.selectedFolder != nil {
                FoldersListingVM.selectedFolder = nil
            }
        }
    }
    
    static var folders                 = [FoldersEntity]()
    static var fetchId                 : String?
    
    
    class func saveFolder(_ folder: FolderData, byOWner: Bool = false) {
        
        let item = NSEntityDescription.insertNewObject(forEntityName: FoldersEntity.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! FoldersEntity
        
        item.id                    = folder.id
        item.serverId              = folder.id
        item.name                  = folder.name
        item.createdAt             = folder.createdAt
        
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        FoldersEntity.selectedFolder = item
    }
    
    class func updateByPredicate(_ folder: FolderData, byServer: Bool = true) {
        
        self.folders = getFolders(false, sortAscending: false, byPredicate: true)
        if self.folders.count > 0 {
            self.selectedFolder = folders[0]
        }
        
        self.selectedFolder?.name = folder.name
        
        if let id = folder.id {
            
            if byServer {
                self.selectedFolder?.serverId = id
            }
            self.selectedFolder?.createdAt = folder.createdAt
            self.selectedFolder?.updatedAt = folder.updatedAt

        }
        
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func saveFolders(_ folders: [FolderData]) {
        
        for folder in folders {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: FoldersEntity.identifier,
                                                           into: PersistenceManager.sharedInstance.getMainContextInstance()) as! FoldersEntity
            
            item.serverId              = folder.id
            item.id                    = folder.id
            item.createdAt             = folder.createdAt
            item.name                  = folder.name
            item.updatedAt             = folder.updatedAt

            self.folders.append(item)
            
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func deleteFolder(_ item: FoldersEntity) {
        
        //Delete event item from persistance layer
        PersistenceManager.sharedInstance.getMainContextInstance().delete(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func getFolders(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false) -> [FoldersEntity] {
        
        var fetchedResults = [FoldersEntity]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FoldersEntity.identifier)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: "createdAt",
                                                  ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            fetchRequest.predicate = predicate1
        }
        
        if byPredicate {
            let predicate1 = NSPredicate(format: "id == %@", self.fetchId ?? "")
            let predicate2 = NSPredicate(format: "serverId == %@", self.fetchId ?? "")
            let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = compound
            
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [FoldersEntity]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [FoldersEntity]()
        }
        
        return fetchedResults
    }
    
    
}


extension FoldersEntity {
    
    class func setFolderId( param: inout [String: Any])-> [String: Any] {
        
        if let folderId = param[App.paramKeys.folderId] as? String {
            FoldersEntity.fetchId = folderId
            let folderItems = FoldersEntity.getFolders(byPredicate: true)
            
            if folderItems.count > 0 {
                param[App.paramKeys.folderId] = folderItems[0].serverId
            }
        }
        
        return param
    }
    
}
