//
//  Archive+CoreDataProperties.swift
//  AIL
//
//  Created by Work on 2/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import CoreData

extension Archive {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Archive> {
//        return NSFetchRequest<Archive>(entityName: "Archive");
//    }

    @NSManaged public var postId: NSNumber?
    @NSManaged public var postTitle: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var link: NSObject?
    @NSManaged public var archiveDate: NSDate?
    @NSManaged public var categories: Category?

}
