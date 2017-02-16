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
    static func checkIdExist(_ id:Int,entityType:EntityType) -> Bool {
        
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: entityType.rawValue, in: managedObjectContext)
        //request.resultType = .CountResultType
        
        // Set up predicate
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate
        
        
        var count = 0
        do {
            count = try managedObjectContext.count(for: request)
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
    static func getRecentEditDateForPost() -> Date?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: EntityType.Post.rawValue, in: managedObjectContext)
        fetchRequest.resultType = .dictionaryResultType
        
        
        // Setup Expression
        let keyPathExpression = NSExpression(forKeyPath: "editDate")
        
        let latestUpdateDateExpression = NSExpression(forFunction: "max", arguments: [keyPathExpression])
        
        let latestUpdateDateExpressionDescription = NSExpressionDescription()
        latestUpdateDateExpressionDescription.name = "latestUpdateDate"
        latestUpdateDateExpressionDescription.expression = latestUpdateDateExpression
        latestUpdateDateExpressionDescription.expressionResultType = .dateAttributeType
        
        // Setup Fetch Request
        
        fetchRequest.propertiesToFetch = [latestUpdateDateExpressionDescription]
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest)
            
            if (fetchResults[0] as AnyObject).value(forKey: "latestUpdateDate") != nil {
                let latestUpdateDate = (fetchResults[0] as AnyObject).value(forKey: "latestUpdateDate") as! Date
                return latestUpdateDate
            }
        } catch{}
        
        return nil
        
    }
    
    static func saveManagedObjectContext() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do{
            try managedObjectContext.save()
        } catch {
            print("Errors when save Core Data managedObjectContext!!")
        }
    }
    
    static func fetchResourcesPostFromCoreData() -> [Post]?{
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let resourcePostFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Post.rawValue)
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        resourcePostFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.fetch(resourcePostFetchRequest) as! [Post]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        
        return nil
    }
    
    
    static func fetchAllMessagesFromCoreData() -> [Message]?{
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let messageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Message.rawValue)
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        messageFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.fetch(messageFetchRequest) as! [Message]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        
        return nil
    }
    
    static func fetchAllArchivesFromCoreData() ->[Archive]? {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let archiveFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Archive.rawValue)
        
        let dateSort = NSSortDescriptor(key: "archiveDate", ascending: false)
        archiveFetchRequest.sortDescriptors=[dateSort]
        
        do {
            let objects = try managedObjectContext.fetch(archiveFetchRequest) as! [Archive]
            return objects
            
            
        } catch {
            print("fetch request errors!")
        }
        return nil
    }
    
    static func createArchiveObject() -> Archive{
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let archive = Archive(entity: NSEntityDescription.entity(forEntityName: "Archive", in: managedObjectContext)!, insertInto: managedObjectContext)
        
        archive.archiveDate = Date()
        return archive
    }
    
    static func deleteManagedObjectFromCoreData(_ objectToDelete:NSManagedObject){
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        managedObjectContext.delete(objectToDelete)
        do {
            try managedObjectContext.save()
        } catch {
            NSLog("Exception when deleting managed object")
        }
    }
    
    
    static func checkMessagePostIdExist(_ postId:Int) -> Bool {
        
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: EntityType.Message.rawValue, in: managedObjectContext)
        request.resultType = .countResultType
        
        // Set up predicate
        let predicate = NSPredicate(format: "postId = %@", "\(postId)")
        request.predicate = predicate
        
        
        var count = 0
        do {
            let result = try managedObjectContext.fetch(request)
            count = result.count
        } catch {
            print("There is error when fetch data count from core data")
        }
        
        if count != 0 {
            return true
        }
        return false
        
    }
    
    static func buildRandomPost(_ id:Int,title:String,excerpt:String,date:Date,link:String) -> Post {
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let postDescription = NSEntityDescription.entity(forEntityName: EntityType.Post.rawValue, in: managedObjectContext)
        
        let post = Post(entity: postDescription!, insertInto: nil)
        
        post.id = id as NSNumber?
        post.title = title
        post.date = date
        post.excerpt = excerpt
        post.link = link
        
        
        return post
    }
    
    
}



enum EntityType:String {
    case Post = "Post"
    case Category = "Category"
    case Message = "Message"
    case Archive = "Archive"
}
