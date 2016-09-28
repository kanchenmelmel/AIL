//
//  RequestOperation.swift
//  AIL
//
//  Created by Work on 6/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData


/* RequestOperation Class
 Responsible for executing HTTP request
 */


class WordPressClient {
    
    
    // Request the latest 20 posts
    func requestLatestTwentyPosts(completionHandler: ([Post]) -> Void) {
        Alamofire.request(.GET, BASE_URL+RESOURSES, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                   // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    CoreDataOperation.saveManagedObjectContext()
                }
            case .Failure: break
            }
        }
        
    }
    
    func requestLatestPostsByCategories(categoryId:Int, completionHandler: ([Post]) -> Void) {
        //159
        let urlArguments = "?categories=\(categoryId)"
        print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(.GET, BASE_URL+RESOURSES+urlArguments, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(false, ifInsertIntoManagedContext: false, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .Failure: break
            }
        }
        
//        Alamofire.request
        
    }
    
    func requestAllPosts(completionHandler: ([Post]) -> Void) {
        let urlArguments = "?filter[posts_per_page]=50"
        print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(.GET, BASE_URL+RESOURSES+urlArguments, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(false, ifInsertIntoManagedContext: false, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .Failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
    func requestAllMessages(completionHandler: ([Message]) -> Void) {
        //let urlArguments = "?filter[posts_per_page]=50"
       // print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(.GET, MESSAGES_URL+MESSAGES_RESOURCES, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToMessageManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                    CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .Failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
}
