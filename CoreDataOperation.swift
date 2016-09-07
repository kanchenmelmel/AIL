//
//  CoreDataOperation.swift
//  AIL
//
//  Created by Work on 6/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperation {
    static func checkIdExist(id:Int,entityType:EntityType) -> Bool {
        
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityType.rawValue, inManagedObjectContext: managedObjectContext)
        //request.resultType = .CountResultType
        
        // Set up predicate
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate
        
        let count = managedObjectContext.countForFetchRequest(request, error: nil)
        
        
        if count != 0 {
            print(true)
            return true
        }
        print(false)
        return false
        
    }
}


enum EntityType:String {
    case Post = "Post"
    case Category = "Category"
}