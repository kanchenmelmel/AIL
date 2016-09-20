//
//  Category+CoreDataProperties.swift
//  AIL
//
//  Created by Work on 20/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import CoreData


extension Category {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
//        return NSFetchRequest<Category>(entityName: "Category");
//    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?

}
