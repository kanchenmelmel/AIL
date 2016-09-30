//
//  JSONParser.swift
//  AIL
//
//  Created by Work on 6/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class JSONParser {
    
    
    static func parseJSONDictionaryToPostManagedObject(checkIfExistInCoreData:Bool,ifInsertIntoManagedContext:Bool,jsonArray:JSON) -> [Post]{
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let postDescription = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        
        var managedObjectContextToBeInserted:NSManagedObjectContext? = managedObjectContext
        
        if !ifInsertIntoManagedContext {
            managedObjectContextToBeInserted = nil
        }
        var posts = [Post]()
        if jsonArray.count <= 0{
            return posts
        }
        for index in 0...jsonArray.count-1 {
           // print ("Jason is \(index)")
            if checkIfExistInCoreData {
                if !CoreDataOperation.checkIdExist(jsonArray[index]["id"].int!, entityType: .Post){
                    let post = Post(entity: postDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                    if jsonArray[index]["id"].isExists() {
                        post.id = jsonArray[index]["id"].int
                    }
                    if jsonArray[index]["title"].isExists() {
                        post.title = jsonArray[index]["title"].stringValue
                    }
                    if jsonArray[index]["link"].isExists() {
                        post.link = jsonArray[index]["link"].stringValue
                    }
                    if jsonArray[index]["date"].isExists() {
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                    }
                    if jsonArray[index]["thumbnail_url"].isExists() {
                        post.thumbnailUrl = jsonArray[index]["thumbnail_url"].stringValue
                    }
                    if jsonArray[index]["featured_image_url"].isExists() {
                        post.featuredImageUrl = jsonArray[index]["featured_image_url"].stringValue
                    }
                    if jsonArray[index]["status"].isExists() {
                        post.status = jsonArray[index]["status"].stringValue
                    }
                    if jsonArray[index]["editdate"].isExists() {
                        let dateFormatter = DateFormatter()
                        post.editDate = dateFormatter.formatDateStringToMelTime(jsonArray[index]["editdate"].stringValue)
                    }
                    if jsonArray[index]["excerpt"].isExists() {
                        post.excerpt = jsonArray[index]["excerpt"].stringValue
                    }
                    posts.append(post)
                    
                }
            } else {
                let post = Post(entity: postDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                if jsonArray[index]["id"].isExists() {
                    post.id = jsonArray[index]["id"].int
                }
                if jsonArray[index]["title"].isExists() {
                    post.title = jsonArray[index]["title"].stringValue
                }
                if jsonArray[index]["link"].isExists() {
                    post.link = jsonArray[index]["link"].stringValue
                }
                if jsonArray[index]["date"].isExists() {
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                }
                if jsonArray[index]["thumbnail_url"].isExists() {
                    post.thumbnailUrl = jsonArray[index]["thumbnail_url"].stringValue
                }
                if jsonArray[index]["featured_image_url"].isExists() {
//                    let url = jsonArray[index]["featured_image_url"].stringValue
//                    post.featuredImageUrl = url
                    post.featuredImageUrl = jsonArray[index]["featured_image_url"].stringValue
                }
                if jsonArray[index]["status"].isExists() {
                    post.status = jsonArray[index]["status"].stringValue
                }
                if jsonArray[index]["editdate"].isExists() {
                    let dateFormatter = DateFormatter()
                    post.editDate = dateFormatter.formatDateStringToMelTime(jsonArray[index]["editdate"].stringValue)
                }
                if jsonArray[index]["excerpt"].isExists() {
                    post.excerpt = jsonArray[index]["excerpt"].stringValue
                }
                posts.append(post)

            }
        }
        return posts
    }
    
    
    
    static func parseJSONDictionaryToMessageManagedObject(checkIfExistInCoreData:Bool,ifInsertIntoManagedContext:Bool,jsonArray:JSON) -> [Message]{
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let messageDescription = NSEntityDescription.entityForName("Message", inManagedObjectContext: managedObjectContext)
        
        var managedObjectContextToBeInserted:NSManagedObjectContext? = managedObjectContext
        
        if !ifInsertIntoManagedContext {
            managedObjectContextToBeInserted = nil
        }
        var messages = [Message]()
        for index in 0...jsonArray.count-1 {
            if checkIfExistInCoreData {
                if !CoreDataOperation.checkIdExist(jsonArray[index]["id"].int!, entityType: .Message){
                    let message = Message(entity: messageDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                    if jsonArray[index]["id"].isExists() {
                        message.id = jsonArray[index]["id"].int
                    }
                    if jsonArray[index]["title"].isExists() {
                        message.title = jsonArray[index]["title"].stringValue
                    }
                    if jsonArray[index]["date"].isExists() {
                        let dateFormatter = DateFormatter()
                        message.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                    }
                    if jsonArray[index]["content"].isExists() {
                        message.content = jsonArray[index]["content"].stringValue
                    }
                    message.viewed = false
                
                    messages.append(message)
                    
                }
            } else {
                let message = Message(entity: messageDescription!, insertIntoManagedObjectContext: managedObjectContextToBeInserted)
                if jsonArray[index]["id"].isExists() {
                    message.id = jsonArray[index]["id"].int
                }
                if jsonArray[index]["title"].isExists() {
                    message.title = jsonArray[index]["title"].stringValue
                }
                if jsonArray[index]["date"].isExists() {
                    let dateFormatter = DateFormatter()
                    message.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                }
                if jsonArray[index]["content"].isExists() {
                    message.content = jsonArray[index]["content"].stringValue
                }
                
                messages.append(message)
                
            }
        }
        return messages
    }
}
