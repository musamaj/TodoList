//
//  CommentEntity+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 10/11/2019.
//
//

import Foundation
import CoreData


extension CommentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentEntity> {
        return NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var content: String?
    @NSManaged public var taskId: String?
    @NSManaged public var userId: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var task: TaskEntity?

}
