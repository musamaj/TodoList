//
//  NSCategory+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 04/11/2019.
//
//

import Foundation
import CoreData


extension NSCategory {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSCategory> {
        return NSFetchRequest<NSCategory>(entityName: "NSCategory")
    }
    
    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var ownerEmail: String?
    @NSManaged public var ownerId: String?
    @NSManaged public var ownerName: String?
    @NSManaged public var rowDeleted: Bool
    @NSManaged public var accepted: Bool
    @NSManaged public var serverId: String?
    @NSManaged public var synced: Bool
    @NSManaged public var updatedAt: String?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var users: NSSet?
    @NSManaged public var folder: FoldersEntity?
    
}

// MARK: Generated accessors for tasks
extension NSCategory {
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskEntity)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskEntity)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}

// MARK: Generated accessors for users
extension NSCategory {
    
    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: SharedUsersEntity)
    
    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: SharedUsersEntity)
    
    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)
    
    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)
    
}
