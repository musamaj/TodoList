//
//  SubtaskEntity+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 10/11/2019.
//
//

import Foundation
import CoreData


extension SubtaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubtaskEntity> {
        return NSFetchRequest<SubtaskEntity>(entityName: "SubtaskEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var done: Bool
    @NSManaged public var descriptionField: String?
    @NSManaged public var taskId: String?
    @NSManaged public var task: TaskEntity?

}
