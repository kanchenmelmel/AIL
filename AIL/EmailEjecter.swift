//
//  EmailEjecter.swift
//  AIL
//
//  Created by Wenyu Zhao on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import Alamofire

class EmailEjector {
    enum BodyType {
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
    
    class func eject(type bodyType: BodyType, from: String, to: String, title: String, body: String) -> Promise<Void, Void> {
        let promise = Promise<Void, Void>()
        let parameters = [ "from": from, "to":  to, "subject": title, "body": body ]
        Alamofire.request(
            .POST,
            url(bodyType),
            parameters: parameters,
            encoding: ParameterEncoding.JSON
        ).responseJSON { response in
            promise.resolve()
        }
        return promise
    }
    
    class func ejectText(from from: String, to: String, title: String, body: String) -> Promise<Void, Void> {
        return eject(type: .TEXT, from: from, to: to, title: title, body: body);
    }
    
    class func ejectHTML(from from: String, to: String, title: String, body: String) -> Promise<Void, Void> {
        return eject(type: .HTML, from: from, to: to, title: title, body: body);
    }
}

