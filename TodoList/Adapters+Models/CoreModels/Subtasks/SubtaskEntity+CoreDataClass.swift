//
//  SubtaskEntity+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 10/11/2019.
//
//

import Foundation
import CoreData

@objc(SubtaskEntity)
public class SubtaskEntity: NSManagedObject {

    static var selectedSubTask        : SubtaskEntity?
    static var subtasks               = [SubtaskEntity]()
    static var fetchId : String?
    
    
    class func saveSubTask(_ subTask: SubtaskData)-> SubtaskEntity {
        
        let item = NSEntityDescription.insertNewObject(forEntityName: SubtaskEntity.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! SubtaskEntity
        
        item.id                    = subTask.id
        item.serverId              = subTask.id
        item.taskId                = TaskEntity.selectedTask?.id ?? TaskEntity.selectedTask?.serverId
        item.descriptionField      = subTask.descriptionField

        
        if let parent = subTask.parentTask {
            item.task                  = parent
        } else {
            item.task                  = TaskEntity.selectedTask
        }
        
        item.createdAt             = subTask.createdAt
        item.done                  = false
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        return item
        
    }
    
    class func updateSubtask(_ task: SubtaskData,_ byPredicate: Bool = false, _ byServer: Bool = true) {
        
        if byPredicate {
            self.subtasks = getSubTasks(false, sortAscending: false, byPredicate: true)
            if self.subtasks.count > 0 {
                self.selectedSubTask = subtasks[0]
            }
        }
        
        self.selectedSubTask?.descriptionField = task.descriptionField
        
        if let id = task.id {
            
            if byServer {
                self.selectedSubTask?.serverId = id
            }
            self.selectedSubTask?.createdAt = task.createdAt
            self.selectedSubTask?.updatedAt = task.updatedAt
            self.selectedSubTask?.done      = task.done ?? false
        }
        
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func saveSubtasks(_ tasks: [SubtaskData]) {
        
        for task in tasks {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: SubtaskEntity.identifier,
                                                           into: PersistenceManager.sharedInstance.getMainContextInstance()) as! SubtaskEntity
            item.serverId              = task.id
            item.id                    = task.id
            item.createdAt             = task.createdAt
            item.descriptionField      = task.descriptionField
            item.updatedAt             = task.updatedAt
            item.done                  = task.done ?? false
            item.taskId                = task.taskId
            item.task                  = TaskEntity.selectedTask
            
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func getSubTasks(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false, byTask: Bool = false) -> [SubtaskEntity] {
        
        var fetchedResults = [SubtaskEntity]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SubtaskEntity.identifier)
        
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
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [SubtaskEntity]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [SubtaskEntity]()
        }
        
        return fetchedResults
    }
    
    class func deleteSubTask(_ item: SubtaskEntity) {
        
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
