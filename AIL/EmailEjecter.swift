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
    
    fileprivate enum BodyType {
        case html
        case text
    }
    
    fileprivate static let DOMAIN = "www.melmel.com.au";
    
    fileprivate class func url(_ bodyType: BodyType) -> String {
        switch bodyType {
        case .html:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/html.php"
        case .text:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/text.php"
        }
    }
    
    fileprivate class func eject_email(type: BodyType, email: Email) -> (@escaping (DataResponse<Any>) -> Void) -> Void {
        let parameters = [
            "from": email.from,
            "to":  email.to,
            "subject": email.title,
            "body": email.content
        ]
        return { callback in
            Alamofire.request(
                url(type),
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: nil
            ).responseJSON(completionHandler: callback)
        }
    }
    
    class func eject(email: Email) -> (@escaping (DataResponse<Any>) -> Void) -> Void {
        return eject_email(type: .text, email: email);
    }
    
    class func ejectHTMLEmail(email: Email) -> (@escaping (DataResponse<Any>) -> Void) -> Void {
        return eject_email(type: .html, email: email);
    }
}

