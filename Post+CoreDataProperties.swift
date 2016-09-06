//
//  Post+CoreDataProperties.swift
//  AIL
//
//  Created by Work on 6/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var link: String?
    @NSManaged var date: NSDate?
    @NSManaged var thumbnailUrl: String?
    @NSManaged var featuredImageUrl: String?
    @NSManaged var status: String?
    @NSManaged var editDate: NSDate?
    @NSManaged var categories: NSSet?

}
