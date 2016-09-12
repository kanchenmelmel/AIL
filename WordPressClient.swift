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


class WordPressClient {
    func requestLatestTwentyPosts(completionHandler: ([Post]) -> Void) {
        print(BASE_URL+RESOURSES)
        Alamofire.request(.GET, BASE_URL+RESOURSES, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value)
                    completionHandler(JSONParser.parseJSONDictionaryToPostManagedObject(true, ifInsertIntoManagedContext: true, jsonArray: jsonArray))
                }
            case .Failure: break
            }
        }
        
    }
}