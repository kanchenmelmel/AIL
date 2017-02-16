//
//  ImageDownloader.swift
//  AIL
//
//  Created by Work on 20/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ImageDownloader: Operation {
    let imageRecord:ImageRecord
    
    init(imageRecord:ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let imageData = try? Data(contentsOf: imageRecord.url)
        
        
        if self.isCancelled {
            return
        }
        
        if imageData?.count > 0 {
            self.imageRecord.image = UIImage(data: imageData!)
            self.imageRecord.state = .downloaded
        } else {
            self.imageRecord.state = .failed
            self.imageRecord.image = UIImage(named: "ImagePlaceholder")
        }
    }
    
    

}

class ImageOperations {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    
    
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
}

class ImageRecord {
    let name:String
    let url:URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "ImagePlaceholder")
    
    init(name:String,url:URL) {
        self.name = name
        self.url = url
    }
    
}

enum PhotoRecordLoadingState {
    case new,downloaded,failed
}
