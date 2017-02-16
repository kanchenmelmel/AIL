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
    
    
    static func parseJSONDictionaryToPostManagedObject(_ checkIfExistInCoreData:Bool,ifInsertIntoManagedContext:Bool,jsonArray:JSON) -> [Post]{
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let postDescription = NSEntityDescription.entity(forEntityName: "Post", in: managedObjectContext)
        
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
                    let post = Post(entity: postDescription!, insertInto: managedObjectContextToBeInserted)
                    if jsonArray[index]["id"].exists() {
                        post.id = jsonArray[index]["id"].number
                    }
                    if jsonArray[index]["title"].exists() {
                        post.title = jsonArray[index]["title"].stringValue
                    }
                    if jsonArray[index]["link"].exists() {
                        post.link = jsonArray[index]["link"].stringValue
                    }
                    if jsonArray[index]["date"].exists() {
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                    }
                    if jsonArray[index]["thumbnail_url"].exists() {
                        post.thumbnailUrl = jsonArray[index]["thumbnail_url"].stringValue
                    }
                    if jsonArray[index]["featured_image_url"].exists() {
                        post.featuredImageUrl = jsonArray[index]["featured_image_url"].stringValue
                    }
                    if jsonArray[index]["status"].exists() {
                        post.status = jsonArray[index]["status"].stringValue
                    }
                    if jsonArray[index]["editdate"].exists() {
                        let dateFormatter = DateFormatter()
                        post.editDate = dateFormatter.formatDateStringToMelTime(jsonArray[index]["editdate"].stringValue)
                    }
                    if jsonArray[index]["excerpt"].exists() {
                        post.excerpt = jsonArray[index]["excerpt"].stringValue
                    }
                    posts.append(post)
                    
                }
            } else {
                let post = Post(entity: postDescription!, insertInto: managedObjectContextToBeInserted)
                if jsonArray[index]["id"].exists() {
                    post.id = jsonArray[index]["id"].number
                }
                if jsonArray[index]["title"].exists() {
                    post.title = jsonArray[index]["title"].stringValue
                }
                if jsonArray[index]["link"].exists() {
                    post.link = jsonArray[index]["link"].stringValue
                }
                if jsonArray[index]["date"].exists() {
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                }
                if jsonArray[index]["thumbnail_url"].exists() {
                    post.thumbnailUrl = jsonArray[index]["thumbnail_url"].stringValue
                }
                if jsonArray[index]["featured_image_url"].exists() {
//                    let url = jsonArray[index]["featured_image_url"].stringValue
//                    post.featuredImageUrl = url
                    post.featuredImageUrl = jsonArray[index]["featured_image_url"].stringValue
                }
                if jsonArray[index]["status"].exists() {
                    post.status = jsonArray[index]["status"].stringValue
                }
                if jsonArray[index]["editdate"].exists() {
                    let dateFormatter = DateFormatter()
                    post.editDate = dateFormatter.formatDateStringToMelTime(jsonArray[index]["editdate"].stringValue)
                }
                if jsonArray[index]["excerpt"].exists() {
                    post.excerpt = jsonArray[index]["excerpt"].stringValue
                }
                posts.append(post)

            }
        }
        return posts
    }
    
    
    
    static func parseJSONDictionaryToMessageManagedObject(_ checkIfExistInCoreData:Bool,ifInsertIntoManagedContext:Bool,jsonArray:JSON) -> [Message]{
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let messageDescription = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext)
        
        var managedObjectContextToBeInserted:NSManagedObjectContext? = managedObjectContext
        
        if !ifInsertIntoManagedContext {
            managedObjectContextToBeInserted = nil
        }
        var messages = [Message]()
        
        if jsonArray.count <= 0{
            return messages
        }
        for index in 0...jsonArray.count-1 {
            if checkIfExistInCoreData {
                if !CoreDataOperation.checkIdExist(jsonArray[index]["id"].int!, entityType: .Message){
                    let message = Message(entity: messageDescription!, insertInto: managedObjectContextToBeInserted)
                    if jsonArray[index]["id"].exists() {
                        message.id = jsonArray[index]["id"].number
                    }
                    if jsonArray[index]["title"].exists() {
                        message.title = jsonArray[index]["title"].stringValue
                    }
                    if jsonArray[index]["date"].exists() {
                        let dateFormatter = DateFormatter()
                        message.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                    }
                    if jsonArray[index]["content"].exists() {
                        message.content = jsonArray[index]["content"].stringValue
                    }
                    message.viewed = false
                
                    messages.append(message)
                    
                }
            } else {
                let message = Message(entity: messageDescription!, insertInto: managedObjectContextToBeInserted)
                if jsonArray[index]["id"].exists() {
                    message.id = jsonArray[index]["id"].number
                }
                if jsonArray[index]["title"].exists() {
                    message.title = jsonArray[index]["title"].stringValue
                }
                if jsonArray[index]["date"].exists() {
                    let dateFormatter = DateFormatter()
                    message.date = dateFormatter.formatDateStringToMelTime(jsonArray[index]["date"].stringValue)
                }
                if jsonArray[index]["content"].exists() {
                    message.content = jsonArray[index]["content"].stringValue
                }
                
                messages.append(message)
                
            }
        }
        return messages
    }
}
