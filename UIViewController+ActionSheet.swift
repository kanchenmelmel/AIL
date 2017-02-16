//
//  UIViewController+ActionSheet.swift
//  AIL
//
//  Created by Work on 3/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    
    
    func showActionSheet(_ title:String?, message:String?,items:[(String,() -> Void)]?,cancleButtonTitle:String?){
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancleAction = UIAlertAction(title: cancleButtonTitle, style: .cancel) { (action) in
            
        }
        
        actionSheet.addAction(cancleAction)
        
        if items != nil {
            for item in items! {
                let actionObject = UIAlertAction(title: item.0, style: .default, handler: { (action) in
                    item.1()
                })
                actionSheet.addAction(actionObject)
            }
        }
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func rightTopBarButtonItemAction(_ post:Post){
        typealias actionClosure = ()-> Void
        
        // Add Share Action
        var items = [(String, actionClosure)]()
        
        items.append(("收藏",{() -> Void in
            self.archivePost(post)
            let alert = Alert()
            alert.showArchivedSuccessfullyAlert(self)
        }))
        
        items.append(("分享",{() -> Void in
            let url = URL(string: post.link!)
            print("Test3")
            let icon = UIImage(named: "WechatShare")
            let activityViewController = UIActivityViewController(activityItems: [post.title!,url!,icon!], applicationActivities: nil)
            self.navigationController?.present(activityViewController, animated: true, completion: {
                
            })
        }))
        self.showActionSheet(nil, message: nil, items: items, cancleButtonTitle: "取消")
    }
    
    
    func archivePost(_ post:Post) {
       // let postId = Int(post.id!)
        
            let archive = CoreDataOperation.createArchiveObject()
            //archive.addToCategories(categories)
            archive.postId = post.id
            
            archive.postTitle = post.title
            archive.excerpt = post.excerpt
            archive.link = post.link
            archive.addToCategories(post.categories!)
            
            CoreDataOperation.saveManagedObjectContext()
        
        
        
    }
    
    
    func applyCSSToUIWebView(_ webView:UIWebView) {
        let cssString = "#Top_bar,.post-nav,footer,header {display:none;}"
        let javascriptString = "var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)"
        let javascriptWithCssString = String(format: javascriptString, cssString)
        webView.stringByEvaluatingJavaScript(from: javascriptWithCssString)
        
    }
    
    func showStandardAlert(_ title:String?,message:String?,okAction:(() -> Void)?,cancleAction:(() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            if cancleAction?() != nil {
                cancleAction!()
            }
        }
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            if okAction?() != nil {
                okAction!()
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension NVActivityIndicatorViewable where Self: UIViewController {
    
//    var activityIndicator:NVActivityIndicatorView?
    public final func startAnimating() {
        self.startAnimating(CGSize(width: 50, height: 50), message: "努力加载中……", messageFont: nil, type: .ballPulse, color: UIColor.tintColor(), padding: 0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil)
    }
    
    
    
    
    
}


