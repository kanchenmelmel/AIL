//
//  ImageOperation.swift
//  AIL
//
//  Created by WuKaipeng on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    
    
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

//class ImageDownloader:NSOperation {
//    let post:Post
//    
//    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    init(post: Post) {
//        self.post = post
//    }
//    
//    override func main() {
//        if self.cancelled {
//            return
//        }
//        
//        
//        
//        if self.cancelled {
//            return
//        }
//        
//        
//        let imageData = NSData(contentsOfURL:NSURL(string:post.featuredImageUrl!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
//        
//    //    let imageData = NSData(contentsOfURL:NSURL(string:post.featuredImageUrl!.stringByAddingPercentEncodingWithAllowedCharacters(NSUTF8StringEncoding)!)!)
//        
//        
//        if imageData?.length != 0 {
//            let image = UIImage(data: imageData!)
//            self.post.featuredImage = image
//            
//            let saver = FileDownloader()
//            saver.saveImageFile(image!, postId: post.id! as Int, fileName: FEATURED_IMAGE_NAME)
//            post.featuredImageDownloadedToFileSys = true
//            try! post.managedObjectContext?.save()
//        }
//            
//        else {
//            self.post.featuredLoadingImageState = .Failed
//            self.post.featuredImage = UIImage(named: "failed")
//            
//        }
//    }
//    
//}
