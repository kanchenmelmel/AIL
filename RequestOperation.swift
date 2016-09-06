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


/* RequestOperation Class
 Responsible for executing HTTP request
 */


class RequestOperation {
    func requestLatestTwentyPosts(completionHandler:([Post])) {
        Alamofire.request(.GET, BASE_URL+RESOURSES, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    var posts = [Post]()
                    let jsonArray = JSON(value)
                    for json in jsonArray {
                        let post = JSONParser.parseJSONToPostManagedObject(true, ifInsertIntoManagedContext: true, json: json)
                        posts.append(post)
                    }
                }
            }
        }
        
    }
}