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
    func requestLatestTwentyPosts(_ completionHandler: @escaping ([Post]) -> Void) {
        
        Alamofire.request(BASE_URL+RESOURSES + "?\(EXCLUDED_CAT_ARGUMENTS)").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                   // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    CoreDataOperation.saveManagedObjectContext()
                }
            case .failure: break
            }
        }
        
    }
    
    func requestLatestPostsByCategories(_ categoryId:Int, completionHandler: @escaping ([Post]) -> Void) {
        //159
        let urlArguments = "?filter[posts_per_page]=-1&categories=\(categoryId)&\(EXCLUDED_CAT_ARGUMENTS)"
        //print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(BASE_URL+RESOURSES+urlArguments).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(false, ifInsertIntoManagedContext: false, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
//        Alamofire.request
        
    }
    
    func requestTestPostsByCategories(_ categoryId:Int, completionHandler: @escaping ([Post]) -> Void) {
        //159
        let urlArguments = "?filter[posts_per_page]=-1&categories=\(categoryId)"
        //print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(BASE_URL+RESOURSES+urlArguments).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(false, ifInsertIntoManagedContext: false, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
    func requestAllPosts(_ completionHandler: @escaping ([Post]) -> Void) {
        let urlArguments = "?filter[posts_per_page]=-1&\(EXCLUDED_CAT_ARGUMENTS)"
        //print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(BASE_URL+RESOURSES+urlArguments).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(false, ifInsertIntoManagedContext: false, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
    
    func requestPreviousPosts(_ beforeDate: Date, excludeID: Int, completionHandler: @escaping ([Post]) -> Void) {
        
        let dateFormatter = DateFormatter()
        let beforeDateString = dateFormatter.formatDateToDateString(beforeDate)
        
        //let url = NSURL(string: "\(baseURIString)?before=\(beforeDateString)&exclude=\(excludeId)")
        let urlArguments = "?before=\(beforeDateString)&exclude=\(excludeID)"
        //print("num: \(BASE_URL+RESOURSES+urlArguments)")
        Alamofire.request(BASE_URL+RESOURSES+urlArguments).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
    func requestAllMessages(_ completionHandler: @escaping ([Message]) -> Void) {
        //let urlArguments = "?filter[posts_per_page]=50"
       // print(BASE_URL+RESOURSES+urlArguments)
        Alamofire.request(MESSAGES_URL+MESSAGES_RESOURCES).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToMessageManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    //CoreDataOperation.saveManagedObjectContext()
                    
                    CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
        //        Alamofire.request
        
        
    }
    
    
    func requestPreviousMessages(_ beforeDate: Date, excludeID: Int, completionHandler: @escaping ([Message]) -> Void) {
        
        let dateFormatter = DateFormatter()
        let beforeDateString = dateFormatter.formatDateToDateString(beforeDate)
        
        //let url = NSURL(string: "\(baseURIString)?before=\(beforeDateString)&exclude=\(excludeId)")
        let urlArguments = "?before=\(beforeDateString)&exclude=\(excludeID)"
        //print("num: \(MESSAGES_URL+MESSAGES_RESOURCES+urlArguments)")
        Alamofire.request(MESSAGES_URL+MESSAGES_RESOURCES+urlArguments).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    // print (jsonArray)
                    completionHandler(JSONParser.parseJSONDictionaryToMessageManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                    
                    // Save Managed Object Context
                    CoreDataOperation.saveManagedObjectContext()
                    
                }
            case .failure: break
            }
        }
        
        //        Alamofire.request
        
    }
    
    
    
    
}
