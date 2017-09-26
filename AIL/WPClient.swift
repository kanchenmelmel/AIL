//
//  WPClient.swift
//  AIL
//
//  Created by Wenyu Zhao on 1/5/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyJSON
import Alamofire

class WPClient {
    private static var _auth: String?
    private static var _user: [String: Any]?
    static var me: [String: Any]? {
        get {
            return self._user;
        }
    }
    static var authorized: Bool {
        get {
            return self._auth != nil;
        }
    }
    static func clear() {
        self._auth = nil
        self._user = nil
    }
    static func authorize(auth: String, completionHandler: @escaping (Bool) -> ()) {
        let headers = [
            "Authorization": "Basic \(auth)",
            "Accept": "application/json"
        ]
        request("http://ail.vic.edu.au/wp-json/wp/v2/users/me", headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    _auth = auth
                    _user = json
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case .failure: completionHandler(false)
            }
        }
    }
    static func user(id: Int, completionHandler: @escaping ([String: Any]?) -> ()) {
        let headers = [
            "Authorization": "Basic YWlsOjFxMnczZTRyQEA=",
            "Accept": "application/json"
        ]
        request("http://ail.vic.edu.au/wp-json/wp/v2/users/\(id)?context=edit", headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value as? [String: Any] {
                    completionHandler(data)
                } else {
                    completionHandler(nil)
                }
            case .failure: completionHandler(nil)
            }
        }
    }
    static func credit(completionHandler: @escaping (Int?) -> ()) {
        if self._auth != nil {
            let userId = _user!["id"]!
            print("Current user id: \(userId)")
            Alamofire.request("http://ail.vic.edu.au/cred.php?field=ID&value=\(userId)").responseJSON { response in
                print(response)
                if let json = response.result.value as? [String: Any] {
                    if json["ok"] as! Bool {
                        completionHandler(json["credit"] as? Int)
                        return
                    }
                }
                completionHandler(nil)
            }
        } else {
            completionHandler(nil)
        }
    }
}



