//
//  FoldersEntity+CoreDataProperties.swift
//  
//
//  Created by Usama Jamil on 22/04/2020.
//
//

import Foundation
import CoreData


extension FoldersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoldersEntity> {
        return NSFetchRequest<FoldersEntity>(entityName: "FoldersEntity")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var rowDeleted: Bool
    @NSManaged public var serverId: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension FoldersEntity {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: NSCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: NSCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
