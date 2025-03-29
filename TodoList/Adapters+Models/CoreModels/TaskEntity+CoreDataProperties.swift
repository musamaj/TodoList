//
//  TaskEntity+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 10/11/2019.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var assigneeId: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var descriptionField: String?
    @NSManaged public var done: Bool
    @NSManaged public var id: String?
    @NSManaged public var listId: String?
    @NSManaged public var note: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var category: NSCategory?
    @NSManaged public var subtasks: NSSet?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for subtasks
extension TaskEntity {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: SubtaskEntity)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: SubtaskEntity)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

// MARK: Generated accessors for comments
extension TaskEntity {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentEntity)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentEntity)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}
