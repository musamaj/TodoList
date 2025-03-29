//
//  SharedUsersEntity+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 21/11/2019.
//
//

import Foundation
import CoreData

@objc(SharedUsersEntity)
public class SharedUsersEntity: NSManagedObject {

    
    static var selectedUser        : SharedUsersEntity?
    static var users               = [SharedUsersEntity]()
    static var fetchId : String?
    
    
    class func addUser(_ user: RegisterUser)-> SharedUsersEntity {
        
        let item = NSEntityDescription.insertNewObject(forEntityName: SharedUsersEntity.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! SharedUsersEntity
        
        item.id                    = user.id
        item.serverId              = user.id
        item.name                  = user.name
        item.email                 = user.email
        
        NSCategory.selectedCategory?.addToUsers(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        return item
    }
    
    class func updateUser(_ user: RegisterUser,_ byPredicate: Bool = false) {
        
        if byPredicate {
            self.users = getUsers(false, sortAscending: false, byPredicate: true)
            if self.users.count > 0 {
                self.selectedUser = users[0]
            }
        }
        
        if let id = user.id {
            
            self.selectedUser?.serverId = id
            self.selectedUser?.name  = user.name
            self.selectedUser?.email = user.email
            
        }
        
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func saveUsers(_ users: [RegisterUser]) {
        
        for user in users {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: SharedUsersEntity.identifier,
                                                           into: PersistenceManager.sharedInstance.getMainContextInstance()) as! SharedUsersEntity
            
            item.serverId              = user.id
            item.id                    = user.id
            item.name                  = user.name
            item.email                 = user.email
            item.createdAt             = user.createdAt
            
            NSCategory.selectedCategory?.addToUsers(item)
            
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func getUsers(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false, byCategory: Bool = false) -> [SharedUsersEntity] {
        
        var fetchedResults = [SharedUsersEntity]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SharedUsersEntity.identifier)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: "createdAt",
                                                  ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        if byPredicate {
            let predicate = NSPredicate(format: "id == %@", self.fetchId ?? "")
            let predicate2 = NSPredicate(format: "serverId == %@", self.fetchId ?? "")
            let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate, predicate2])
            fetchRequest.predicate = compound
        }
        
        if byCategory {
            let categoryPredicate = NSPredicate(format: "sharedCategory.id MATCHES %@", NSCategory.selectedCategory?.id ?? NSCategory.selectedCategory?.serverId ?? "")
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate1])
            fetchRequest.predicate = compound
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [SharedUsersEntity]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [SharedUsersEntity]()
        }
        
        return fetchedResults
    }
    
    class func deleteUser(_ item: SharedUsersEntity) {
        
        //Delete event item from persistance layer
        PersistenceManager.sharedInstance.getMainContextInstance().delete(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func deleteByPredicate(entity: String) {
        let delegate = application.delegate as! AppDelegate
        let context = delegate.contextManager.mainManagedObjectContextInstance
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let categoryPredicate = NSPredicate(format: "sharedCategory.id MATCHES %@", NSCategory.selectedCategory?.id ?? NSCategory.selectedCategory?.serverId ?? "")
        deleteFetch.predicate = categoryPredicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}
