//
//  SelfTestDBWebViewController.swift
//  AIL
//
//  Created by Work on 27/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class SelfTestDBWebViewController: UIViewController,UIWebViewDelegate {
    
    
    
    
    // Properties for requesting post list
    var categoryId = 0
    var resourcesPosts = [Post]()
    
    
    let client = WordPressClient()

    
    // Porperties for web view

    var post:Post?
    
    var urlString:String?
    
    var loading = false
    var timer:NSTimer? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    
    // Tool bar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.requestPosts { 
            self.progressView.progress  = 0
            
            self.webView.delegate = self
            
            
            self.urlString = self.post?.link?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            
//            self.titleString = self.post?.title
            let url = NSURL(string:self.urlString!)
            
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
            //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
            self.webView.loadRequest(request as NSURLRequest)
            
        }
        
//        progressView.progress  = 0
//        let url = NSURL(string:urlString!)
//        
//        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
//        //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
//        webView.loadRequest(request as NSURLRequest)
//        webView.delegate = self
        
        
    }
    
    
    
    
    
    @IBAction func showActivityViewController(sender: AnyObject) {
        
        
        //        let url = NSURL(string: urlString!)
        //        print("Test3")
        //        let activityViewController = UIActivityViewController(activityItems: [titleString!,url!], applicationActivities: nil)
        //        self.navigationController?.presentViewController(activityViewController, animated: true, completion: {
        //
        //        })
        
        
        self.rightTopBarButtonItemAction(self.post!)
    }
    
    
    
    
    
    // Web View Start Load page
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
        //        timer = NSTimer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
    }
    
    // Web View Finish Loading Page
    func webViewDidFinishLoad(webView: UIWebView) {
        //applyCSSToUIWebView(webView)
        loading = false
        self.stopAnimating()
    }
    
    func updateProgressView (){
        if loading {
            
            if progressView.progress < 0.95 {
                progressView.progress += 0.005
            }
            else {
                progressView.progress = 0.95
            }
        }
        else {
            progressView.hidden = true
            timer?.invalidate()
        }
    }
    
    
    func requestPosts(completionHandler:() -> Void) {
        self.startAnimating()
        client.requestTestPostsByCategories(categoryId) { (posts) in
            
            self.resourcesPosts = posts.shuffle()
            print(posts.count)
            
            self.post = self.resourcesPosts[0]
            
            completionHandler()
            
            
            
            
        }
    }
    
}
