//
//  CommentEntity+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 10/11/2019.
//
//

import Foundation
import CoreData

@objc(CommentEntity)
public class CommentEntity: NSManagedObject {

    static var selectedComment        : CommentEntity?
    static var comments               = [CommentEntity]()
    static var fetchId : String?
    
    
    class func saveComment(_ comment: CommentData, byOWner: Bool = false)-> CommentEntity {
        
        let item = NSEntityDescription.insertNewObject(forEntityName: CommentEntity.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! CommentEntity
        
        item.id                    = comment.id
        item.serverId              = comment.id
        item.taskId                = TaskEntity.selectedTask?.id ?? TaskEntity.selectedTask?.serverId
        item.content               = comment.content
        
        if let parent = comment.parentTask {
            item.task                  = parent
        } else {
            item.task                  = TaskEntity.selectedTask
        }
        
        item.createdAt             = comment.createdAt
        
        if byOWner {
            item.userId                = comment.userId?.id
            item.username              = comment.userId?.name
            item.email                 = comment.userId?.email
        } else {
            item.userId                = Persistence.shared.currentUserID
            item.username              = Persistence.shared.currentUserUsername
            item.email                 = Persistence.shared.currentUserEmail
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        return item
    }
    
    class func updateComment(_ comment: CommentData,_ byPredicate: Bool = false) {
        
        if byPredicate {
            self.comments = getComments(false, sortAscending: false, byPredicate: true)
            if self.comments.count > 0 {
                self.selectedComment = comments[0]
            }
        }
        
        self.selectedComment?.content = comment.content
        
        if let id = comment.id {
            
            self.selectedComment?.serverId = id
            self.selectedComment?.createdAt = comment.createdAt
            self.selectedComment?.updatedAt = comment.updatedAt
        }
        
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func saveComments(_ comments: [CommentData]) {
        
        for comment in comments {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: CommentEntity.identifier,
                                                           into: PersistenceManager.sharedInstance.getMainContextInstance()) as! CommentEntity
            
            item.id                    = comment.id
            item.serverId              = comment.id
            item.createdAt             = comment.createdAt
            item.content               = comment.content
            item.updatedAt             = comment.updatedAt
            item.taskId                = comment.taskId
            item.task                  = TaskEntity.selectedTask
            item.userId                = comment.userId?.id
            item.username              = comment.userId?.name
            item.email                 = comment.userId?.email
            
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func getComments(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false, byTask: Bool = false) -> [CommentEntity] {
        
        var fetchedResults = [CommentEntity]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CommentEntity.identifier)
        
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
        
        if byTask {
            let categoryPredicate = NSPredicate(format: "task.id MATCHES %@", TaskEntity.selectedTask?.id ?? "")
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate1])
            fetchRequest.predicate = compound
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [CommentEntity]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [CommentEntity]()
        }
        
        return fetchedResults
    }
    
    class func deleteComment(_ item: CommentEntity) {
        
        //Delete event item from persistance layer
        PersistenceManager.sharedInstance.getMainContextInstance().delete(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func deleteByPredicate(entity: String) {
        let delegate = application.delegate as! AppDelegate
        let context = delegate.contextManager.mainManagedObjectContextInstance
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let categoryPredicate = NSPredicate(format: "task.id MATCHES %@", TaskEntity.selectedTask?.id ?? "")
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
