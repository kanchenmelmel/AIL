//
//  UIViewController+ActionSheet.swift
//  AIL
//
//  Created by Work on 3/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    
    func showActionSheet(title:String?, message:String?,items:[(String,() -> Void)]?,cancleButtonTitle:String?){
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let cancleAction = UIAlertAction(title: cancleButtonTitle, style: .Cancel) { (action) in
            
        }
        
        actionSheet.addAction(cancleAction)
        
        if items != nil {
            for item in items! {
                let actionObject = UIAlertAction(title: item.0, style: .Default, handler: { (action) in
                    item.1()
                })
                actionSheet.addAction(actionObject)
            }
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func rightTopBarButtonItemAction(post:Post){
        typealias actionClosure = ()-> Void
        
        // Add Share Action
        var items = [(String, actionClosure)]()
        
        items.append(("收藏",{() -> Void in
            self.archivePost(post)
        }))
        
        items.append(("分享",{() -> Void in
            let url = NSURL(string: post.link!)
            print("Test3")
            let activityViewController = UIActivityViewController(activityItems: [post.title!,url!], applicationActivities: nil)
            self.navigationController?.presentViewController(activityViewController, animated: true, completion: {
                
            })
        }))
        self.showActionSheet(nil, message: nil, items: items, cancleButtonTitle: "取消")
    }
    
    
    func archivePost(post:Post) {
        let archive = CoreDataOperation.createArchiveObject()
        //archive.addToCategories(categories)
        archive.postId = post.id
        archive.postTitle = post.title
        archive.excerpt = post.excerpt
        archive.link = post.link
        archive.addToCategories(post.categories!)
        
        CoreDataOperation.saveManagedObjectContext()
        
    }
}
