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
        for index in 0...jsonArray.count-1 {
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
                    posts.append(post)
                    
                }
            }
        }
        
        return posts
    }
}