//
//  PostRetriever.swift
//  AIL
//
//  Created by WuKaipeng on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import CoreData


class PostRetriever{
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func fetchPosts() -> [Post]{
        
        var posts = [Post]()
        let postRequest = NSFetchRequest()

        postRequest.entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        postRequest.sortDescriptors=[dateSort]

        let httpString = "http"
        let predicate = NSPredicate(format: "featuredImageUrl contains[c] %@", httpString)
        postRequest.predicate = predicate

        do{
            let results = try managedObjectContext.executeFetchRequest(postRequest) as! [Post]

                posts = results
                return posts

        }catch {
            print ("Error: Could not fetch featured Posts")
        }
        
        return posts

    }
    
    
    
    
    
    
}
