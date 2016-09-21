//
//  EmailEjecter.swift
//  AIL
//
//  Created by Wenyu Zhao on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import Alamofire

struct Email {
    var from: String
    var to: String
    var title: String
    var content: String
    
}

class EmailEjector {
    
    private enum BodyType {
        case HTML
        case TEXT
    }
    
    private static let DOMAIN = "www.melmel.com.au";
    
    private class func url(bodyType: BodyType) -> String {
        switch bodyType {
        case .HTML:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/html.php"
        case .TEXT:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/text.php"
        }
    }
    
    private class func eject_email(type type: BodyType, email: Email) -> (Response<AnyObject, NSError> -> Void) -> Void {
        let parameters = [
            "from": email.from,
            "to":  email.to,
            "subject": email.title,
            "body": email.content
        ]
        return { callback in
            Alamofire.request(
                .POST,
                url(type),
                parameters: parameters,
                encoding: ParameterEncoding.JSON
            ).responseJSON(completionHandler: callback)
        }
    }
    
    class func eject(email email: Email) -> (Response<AnyObject, NSError> -> Void) -> Void {
        return eject_email(type: .TEXT, email: email);
    }
    
    class func ejectHTMLEmail(email email: Email) -> (Response<AnyObject, NSError> -> Void) -> Void {
        return eject_email(type: .HTML, email: email);
    }
}

