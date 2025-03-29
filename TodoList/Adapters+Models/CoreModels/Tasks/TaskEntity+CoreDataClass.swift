//
//  NSTask+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 04/11/2019.
//
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {

    static var selectedTask        : TaskEntity?
    static var tasks               = [TaskEntity]()
    static var fetchId             : String?
    static var filterKeyword       : String?
    
    
    class func saveTask(_ task: TaskData)-> TaskEntity {
        
        let item = NSEntityDescription.insertNewObject(forEntityName: TaskEntity.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! TaskEntity
        
        item.id                    = task.id
        item.serverId              = task.id
        item.listId                = NSCategory.selectedCategory?.id
        item.listName              = NSCategory.selectedCategory?.name
        item.descriptionField      = task.descriptionField
        item.createdAt             = task.createdAt
        item.done                  = false
        
        if let parent = task.parentCategory {
            //item.category              = parent
            parent.addToTasks(item)
        } else {
            //item.category              = NSCategory.selectedCategory
            NSCategory.selectedCategory?.addToTasks(item)
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        return item
    }
    
    class func updateTask(_ task: TaskData,_ byPredicate: Bool = false, _ byServer: Bool = true) {
        
        if byPredicate {
            self.tasks = getTasks(false, sortAscending: false, byPredicate: true)
            if self.tasks.count > 0 {
                self.selectedTask = tasks[0]
            }
        }
        
        self.selectedTask?.descriptionField = task.descriptionField
        
        if let id = task.id {
            
            if byServer {
                self.selectedTask?.serverId     = id
            } else {
                self.selectedTask?.remindAt         = task.remindAt
            }
            
            self.selectedTask?.createdAt        = task.createdAt
            self.selectedTask?.updatedAt        = task.updatedAt
            self.selectedTask?.done             = task.done ?? false
            self.selectedTask?.note             = task.note
            self.selectedTask?.dueDate          = task.dueDate
            
            self.selectedTask?.assigneeId       = task.assigneeId?.id
            self.selectedTask?.assigneeName     = task.assigneeId?.name
            self.selectedTask?.assigneeEmail    = task.assigneeId?.email
            
        }

        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func saveTasks(_ tasks: [TaskData]) {
        
        for task in tasks {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: TaskEntity.identifier,
                                                           into: NSCategory.selectedCategory?.managedObjectContext ?? PersistenceManager.sharedInstance.getMainContextInstance()) as! TaskEntity
            
            
            item.serverId              = task.id
            item.id                    = task.id
            item.createdAt             = task.createdAt
            item.descriptionField      = task.descriptionField
            
            item.assigneeId            = task.assigneeId?.id
            item.assigneeName          = task.assigneeId?.name
            item.assigneeEmail         = task.assigneeId?.email
            
            item.updatedAt             = task.updatedAt
            item.done                  = task.done ?? false
            item.listId                = task.listId
            item.note                  = task.note
            item.dueDate               = task.dueDate
            
            //item.category              = NSCategory.selectedCategory
            
            item.listName              = NSCategory.selectedCategory?.name
            NSCategory.selectedCategory?.addToTasks(item)
            
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func getTasks(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false, byCategory: Bool = false, byQuery: Bool = false) -> [TaskEntity] {
        
        var fetchedResults = [TaskEntity]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TaskEntity.identifier)
        
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
            let categoryPredicate = NSPredicate(format: "category.id MATCHES %@", NSCategory.selectedCategory?.id ?? NSCategory.selectedCategory?.serverId ?? "")
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate1])
            fetchRequest.predicate = compound
        }
        
        if byQuery {
            let categoryPredicate = NSPredicate(format: "descriptionField CONTAINS[cd] %@", filterKeyword ?? "")
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate1])
            fetchRequest.predicate = compound
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [TaskEntity]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [TaskEntity]()
        }
        
        return fetchedResults
    }
    
    class func deleteTask(_ item: TaskEntity) {
        
        //Delete event item from persistance layer
        PersistenceManager.sharedInstance.getMainContextInstance().delete(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func deleteByPredicate(entity: String) {
        let delegate = application.delegate as! AppDelegate
        let context = delegate.contextManager.mainManagedObjectContextInstance
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let categoryPredicate = NSPredicate(format: "category.id MATCHES %@", NSCategory.selectedCategory?.id ?? NSCategory.selectedCategory?.serverId ?? "")
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
