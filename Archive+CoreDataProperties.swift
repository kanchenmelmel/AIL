//
//  Archive+CoreDataProperties.swift
//  AIL
//
//  Created by Work on 3/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import CoreData 

extension Archive {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Archive> {
//        return NSFetchRequest<Archive>(entityName: "Archive");
//    }

    @NSManaged public var archiveDate: Date?
    @NSManaged public var excerpt: String?
    @NSManaged public var link: String?
    @NSManaged public var postId: NSNumber?
    @NSManaged public var postTitle: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Archive {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
