//
//  SharedUsersEntity+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 21/11/2019.
//
//

import Foundation
import CoreData


extension SharedUsersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SharedUsersEntity> {
        return NSFetchRequest<SharedUsersEntity>(entityName: "SharedUsersEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var serverId: String?
    @NSManaged public var sharedCategory: NSCategory?
    @NSManaged public var rowDeleted: Bool
    @NSManaged public var createdAt: String?

}
