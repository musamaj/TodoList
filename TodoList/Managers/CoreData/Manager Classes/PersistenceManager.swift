//
//  PerManager.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

//enum EntityTypes: String {
//    case Category = "Category"
//    //case Foo = "Foo"
//    //case Bar = "Bar"
//    
//}



import Foundation
import CoreData

/**
    Persistence manager will delegate to ContextManager to handle Minion-,
    Main- and Master context to merge and save.
*/
class PersistenceManager: NSObject {

    fileprivate var appDelegate: AppDelegate
    fileprivate var mainContextInstance: NSManagedObjectContext

    //Utilize Singleton pattern by instanciating PersistenceManager only once.
    class var sharedInstance: PersistenceManager {
        struct Singleton {
            static let instance = PersistenceManager()
        }

        return Singleton.instance
    }

    //static var sharedInstance: PersistenceManager = PersistenceManager()
    
    override init() {
        appDelegate = AppDelegate().sharedInstance()
        mainContextInstance = ContextManager.init().mainManagedObjectContextInstance
        mainContextInstance.mergePolicy = NSMergePolicy.init(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        super.init()
    }

    /**
        Get a reference to the Main Context Instance
    
        - Returns: Main NSmanagedObjectContext
    */
    func getMainContextInstance() -> NSManagedObjectContext {
        return self.mainContextInstance
    }
    
    func returnWorker()-> NSManagedObjectContext {
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = PersistenceManager.sharedInstance.getMainContextInstance()
        
        return minionManagedObjectContextWorker
    }

    /**
        Save the current work/changes done on the worker contexts (the minion workers).
        
        - Parameter workerContext: NSManagedObjectContext The Minion worker Context that has to be saved.
        - Returns: Void
    */
    func saveWorkerContext(_ workerContext: NSManagedObjectContext) {
        //Persist new Event to datastore (via Managed Object Context Layer).
        do {
            try workerContext.save()
        } catch let saveError as NSError {
            print("save minion worker error: \(saveError.localizedDescription)")
        }
    }

    /**
        Save and merge the current work/changes done on the minion workers with Main context.
    
        - Returns: Void
    */
    func mergeWithMainContext() {
        do {
            try self.mainContextInstance.save()
        } catch let saveError as NSError {
            print("synWithMainContext error: \(saveError.localizedDescription)")
        }
    }
    
    func deleteAllRecords(entity: String) {
        let delegate = application.delegate as! AppDelegate
        let context = delegate.contextManager.mainManagedObjectContextInstance
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    /// Clear all the data that we've stored in Core Data
//    private func clearCaches() {
//        guard let container = contain else {
//            return
//        }
//        container.viewContext.performAndWait {
//            let entities = container.managedObjectModel.entities
//            for entity in entities {
//                guard let name = entity.name else {
//                    // Not sure what to do in this case
//                    continue
//                }
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
//                    entityName: name
//                )
//                let deleteRequest = NSBatchDeleteRequest(
//                    fetchRequest: fetchRequest
//                )
//                // Ignore the error since I'm not sure what to do if it fails
//                _ = try? container.persistentStoreCoordinator.execute(
//                    deleteRequest,
//                    with: container.viewContext
//                )
//            }
//            _ = try? container.viewContext.save()
//        }
//    }

}
