//
//  ImageDownloader.swift
//  AIL
//
//  Created by Work on 20/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import Alamofire

class ImageDownloader: NSOperation {
    let imageRecord:ImageRecord
    
    init(imageRecord:ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: imageRecord.url)
        
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.imageRecord.image = UIImage(data: imageData!)
            self.imageRecord.state = .Downloaded
        } else {
            self.imageRecord.state = .Failed
            self.imageRecord.image = UIImage(named: "ImagePlaceholder")
        }
    }
    
    

}

class ImageOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    
    
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
}

class ImageRecord {
    let name:String
    let url:NSURL
    var state = PhotoRecordState.New
    var image = UIImage(named: "ImagePlaceholder")
    
    init(name:String,url:NSURL) {
        self.name = name
        self.url = url
    }
    
}

enum PhotoRecordLoadingState {
    case new,downloaded,failed
}
