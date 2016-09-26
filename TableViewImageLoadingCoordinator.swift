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
    
    func suspendAllOperations(){
        pendingOperations.downloadQueue.suspended = true
    }
    
    
    func resumeAllOperations(){
        pendingOperations.downloadQueue.suspended = false
        
    }
    
    func loadImagesForOnScreenCells(indexPaths: [NSIndexPath], completionhandler:(indexPath:NSIndexPath)->Void){
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(indexPaths)
        toBeCancelled.subtractInPlace(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtractInPlace(allPendingOperations)
        
        for indexPath in toBeCancelled{
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath]{
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
            
        }
        
        for indexPath in toBeStarted{
            let indexPath = indexPath as NSIndexPath
//            let recordToProcess = posts[indexPath.row]
//            print("test")
            let imageRecord = self.imageRecords[indexPath.row]
            //startOperationsForPhoto(recordToProcess, indexPath: indexPath)
            self.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                completionhandler(indexPath: indexPath)
            })
        }

    }
    
    
}
