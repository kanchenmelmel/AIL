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
        
        
        var count = 0
        do {
            count = try managedObjectContext.countForFetchRequest(request)
        } catch {
            print("There is error when fetch data count from core data")
        }
        
        if count != 0 {
            return true
        }
        print(false)
        return false
        
    }
    
    
    /* 
     This Function returns the latest date of edit date of all posts in Core Data
     */
    static func getRecentEditDateForPost() -> NSDate?{
        let fetchRequest = NSFetchRequest()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchRequest.entity = NSEntityDescription.entityForName(EntityType.Post.rawValue, inManagedObjectContext: managedObjectContext)
        fetchRequest.resultType = .DictionaryResultType
        
        
        // Setup Expression
        let keyPathExpression = NSExpression(forKeyPath: "editDate")
        
        let latestUpdateDateExpression = NSExpression(forFunction: "max", arguments: [keyPathExpression])
        
        let latestUpdateDateExpressionDescription = NSExpressionDescription()
        latestUpdateDateExpressionDescription.name = "latestUpdateDate"
        latestUpdateDateExpressionDescription.expression = latestUpdateDateExpression
        latestUpdateDateExpressionDescription.expressionResultType = .DateAttributeType
        
        // Setup Fetch Request
        
        fetchRequest.propertiesToFetch = [latestUpdateDateExpressionDescription]
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if fetchResults[0].valueForKey("latestUpdateDate") != nil {
                let latestUpdateDate = fetchResults[0].valueForKey("latestUpdateDate") as! NSDate
                return latestUpdateDate
            }
        } catch{}
        
        return nil
        
    }
    
    static func saveManagedObjectContext() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do{
            try managedObjectContext.save()
        } catch {
            print("Errors when save Core Data managedObjectContext!!")
        }
    }
    
    static func fetchResourcesPostFromCoreData() -> [Post]?{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let resourcePostFetchRequest = NSFetchRequest(entityName: EntityType.Post.rawValue)
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        resourcePostFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(resourcePostFetchRequest) as! [Post]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        
        return nil
    }
    
    
    static func fetchAllMessagesFromCoreData() -> [Message]?{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let messageFetchRequest = NSFetchRequest(entityName: EntityType.Message.rawValue)
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        messageFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(messageFetchRequest) as! [Message]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        
        return nil
    }
    
    static func fetchAllArchivesFromCoreData() ->[Archive]? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let archiveFetchRequest = NSFetchRequest(entityName: EntityType.Archive.rawValue)
        
        let dateSort = NSSortDescriptor(key: "archiveDate", ascending: false)
        archiveFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(archiveFetchRequest) as! [Archive]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        return nil
    }
    
    static func createArchiveObject() -> Archive{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let archive = Archive(entity: NSEntityDescription.entityForName("Archive", inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
        
        archive.archiveDate = NSDate()
        return archive
    }
    
    static func deleteManagedObjectFromCoreData(objectToDelete:NSManagedObject){
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        managedObjectContext.deleteObject(objectToDelete)
        do {
            try managedObjectContext.save()
        } catch {
            NSLog("Exception when deleting managed object")
        }
    }
    
    
}



enum EntityType:String {
    case Post = "Post"
    case Category = "Category"
    case Message = "Message"
    case Archive = "Archive"
}
