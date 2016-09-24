//
//  Post+CoreDataProperties.swift
//  AIL
//
//  Created by Work on 22/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import CoreData

extension Post {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
//        return NSFetchRequest<Post>(entityName: "Post");
//    }

    @NSManaged public var date: NSDate?
    @NSManaged public var editDate: NSDate?
    @NSManaged public var featuredImageDownloadedToFileSys: NSNumber?
    @NSManaged public var featuredImageUrl: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var link: String?
    @NSManaged public var status: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Post {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
