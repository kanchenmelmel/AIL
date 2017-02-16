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
    
    
    func startOperationsForImageRecord(_ imageRecord:ImageRecord,indexPath:IndexPath,completionhandler:@escaping () -> Void){
        switch (imageRecord.state) {
        case .new:
            self.startdownloadForRecord(imageRecord, indexPath: indexPath, completionHandler: {
                completionhandler()
            })
        default:
            print("do nothing")
        }
    }
    
    func startdownloadForRecord(_ imageRecord:ImageRecord,indexPath:IndexPath,completionHandler:@escaping () -> Void) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        let downloader = ImageDownloader(imageRecord: imageRecord)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                completionHandler()
            })
            
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations(){
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    
    func resumeAllOperations(){
        pendingOperations.downloadQueue.isSuspended = false
        
    }
    
    func loadImagesForOnScreenCells(_ indexPaths: [IndexPath], completionhandler:@escaping (_ indexPath:IndexPath)->Void){
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(indexPaths)
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled{
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath]{
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
        }
        
        for indexPath in toBeStarted{
            let indexPath = indexPath as IndexPath
//            let recordToProcess = posts[indexPath.row]
//            print("test")
            let imageRecord = self.imageRecords[indexPath.row]
            //startOperationsForPhoto(recordToProcess, indexPath: indexPath)
            self.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                completionhandler(indexPath)
            })
        }

    }
    
    
}
