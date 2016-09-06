//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var categoryId: NSNumber?
    @NSManaged var categoryName: String?

}
