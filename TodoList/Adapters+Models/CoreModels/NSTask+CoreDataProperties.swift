//
//  NSTask+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 04/11/2019.
//
//

import Foundation
import CoreData


extension NSTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSTask> {
        return NSFetchRequest<NSTask>(entityName: "NSTask")
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

}
