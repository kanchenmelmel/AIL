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
    private static let oauth = OAuth1Swift(
        consumerKey:    "mKlDVzmTLls9",
        consumerSecret: "ly8suK3daYWLgKYzgYN0CO20RjW7RwbG9Jm4RwdpPoo7n6FI",
        requestTokenUrl: "http://ail.vic.edu.au/oauth1/request",
        authorizeUrl:    "http://ail.vic.edu.au/oauth1/authorize",
        accessTokenUrl:  "http://ail.vic.edu.au/oauth1/access"
    )
    //private static var credential: OAuthSwiftCredential? = nil
    //private static var parameters: OAuthSwift.Parameters? = nil
    fileprivate static var client = oauth.client
    static var params: OAuthSwift.Parameters = [:]
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    static func authorize(completionHandler: @escaping (Bool) -> ()) {
        /*if let tok = kvstore.string(forKey: "oauth_token"), let tok_sec = kvstore.string(forKey: "oauth_token_secret"), let params = kvstore.dictionary(forKey: "oauth_parameters") {
            oauth.client.credential.oauthToken = tok
            oauth.client.credential.oauthTokenSecret = tok_sec
            WPClient.params = params
            completionHandler(true)
        } else {*/
            oauth.authorize(
                withCallbackURL: URL(string: "AIL://oauth-callback/ail")!,
                success: { credential, response, parameters in
                
                    kvstore.set(parameters, forKey: "oauth_parameters")
                    WPClient.params = parameters
                    print(credential.authorizationHeader(method: .GET, url: URL(string: "http://ail.vic.edu.au/wp-json/wp/v2/users/me")!, parameters: params))
                    
                    oauth.client.get("http://ail.vic.edu.au/wp-json/wp/v2/users/me",
                        success: { response in
                            print(response.string!);
                            //completionHandler(nil)
                        }, failure: { error in
                            print(error)
                            //completionHandler(nil)
                        }
                    )
                    completionHandler(true)
                },
                failure: { error in
                    print(error.localizedDescription)
                    completionHandler(false)
                    //print(error.localizedDescription)
                }
            )
        //}
    }
    static func users(completionHandler: @escaping (JSON?) -> ()) {
        /*let a = oauth.client.get("http://ail.vic.edu.au/wp-json/wp/v2/users/me",
            success: { response in
                print(response.string!);
                completionHandler(nil)
            }, failure: { error in
                print(error)
                completionHandler(nil)
            }
        )*/
    }
}



