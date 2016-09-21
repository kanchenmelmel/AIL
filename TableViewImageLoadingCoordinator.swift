//
//  TableViewImageLoadingCoordinator.swift
//  AIL
//
//  Created by Work on 20/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation

class TableViewImageLoadingCoordinator {
    var imageRecords = [ImageRecord]()
    let pendingOperations = ImageOperations()
    
    
    func startOperationsForImageRecord(imageRecord:ImageRecord,indexPath:NSIndexPath,completionhandler:() -> Void){
        switch (imageRecord.state) {
        case .New:
            self.startdownloadForRecord(imageRecord, indexPath: indexPath, completionHandler: {
                completionhandler()
            })
        default:
            print("do nothing")
        }
    }
    
    func startdownloadForRecord(imageRecord:ImageRecord,indexPath:NSIndexPath,completionHandler:() -> Void) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        let downloader = ImageDownloader(imageRecord: imageRecord)
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                completionHandler()
            })
            
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
}
