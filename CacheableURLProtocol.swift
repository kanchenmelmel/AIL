//
//  CacheableURLProtocol.swift
//  AIL
//
//  Created by Wenyu Zhao on 12/1/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import UIKit
import CoreData


var requestCount = 0

class CacheableURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    var dataTask:URLSessionDataTask?
    var urlResponse: URLResponse?
    var receivedData: NSMutableData?
    
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "CacheableURLProtocolHandledKey", in: request) != nil {
            return false
        }
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override class func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to:bRequest)
    }
    
    
    override func startLoading() {
        requestCount+=1
        //print("Request \(requestCount): \(request.url!.absoluteString)")
        
        let possibleCachedResponse = self.cachedResponseForCurrentRequest()
        if let cachedResponse = possibleCachedResponse {
            //print("----- Get response data from cache -----")
            
            let data = cachedResponse.value(forKey: "data") as! Data!
            let mimeType = cachedResponse.value(forKey: "mimeType") as! String!
            let encoding = cachedResponse.value(forKey: "encoding") as! String!
            let timestamp = cachedResponse.value(forKey: "timestamp") as! Date!
            
            if timestamp?.compare(Date().addingTimeInterval(-1209600.0)) == .orderedAscending {
                return self.fetchFromInternet()
            }
            let response = URLResponse(
                url: self.request.url!,
                mimeType: mimeType,
                expectedContentLength: (data?.count)!,
                textEncodingName: encoding
            )
            
            self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client!.urlProtocol(self, didLoad: data!)
            self.client!.urlProtocolDidFinishLoading(self)
        } else {
            self.fetchFromInternet()
        }
    }
    
    func fetchFromInternet() {
        //print("----- Get response data from internet -----")
        
        let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "CacheableURLProtocolHandledKey", in: newRequest)
        
        let defaultConfigObj = URLSessionConfiguration.default
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
                                          delegate: self, delegateQueue: nil)
        self.dataTask = defaultSession.dataTask(with: newRequest as URLRequest)
        self.dataTask!.resume()
    }
    
    
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask       = nil
        self.receivedData   = nil
        self.urlResponse    = nil
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.urlResponse = response
        self.receivedData = NSMutableData()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        self.receivedData?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil && error!._code != NSURLErrorCancelled {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            saveCachedResponse()
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    func saveCachedResponse () {
        //print("----- Cache response data -----")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context) as NSManagedObject
        cachedResponse.setValue(self.receivedData, forKey: "data")
        cachedResponse.setValue(self.request.url!.absoluteString, forKey: "url")
        cachedResponse.setValue(Date(), forKey: "timestamp")
        cachedResponse.setValue(self.urlResponse?.mimeType, forKey: "mimeType")
        cachedResponse.setValue(self.urlResponse?.textEncodingName, forKey: "encoding")
        
        DispatchQueue.main.async(execute: {
            do {
                try context.save()
            } catch {
                //print("不能保存：\(error)")
            }
        })
    }
    
    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "CachedURLResponse", in: context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format:"url == %@", self.request.url!.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let possibleResult = try context.fetch(fetchRequest) as? Array<NSManagedObject>
            if let result = possibleResult {
                if !result.isEmpty {
                    return result[0]
                }
            }
        } catch {
            //print("Faild to fetch data：\(error)")
        }
        return nil
    }
}
