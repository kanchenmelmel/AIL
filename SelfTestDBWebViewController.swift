//
//  SelfTestDBWebViewController.swift
//  AIL
//
//  Created by Work on 27/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SelfTestDBWebViewController: UIViewController,UIWebViewDelegate, NVActivityIndicatorViewable {
    
    
    
    
    // Properties for requesting post list
    var categoryId = 0
    var resourcesPosts = [Post]()
    
    
    let client = WordPressClient()

    
    // Porperties for web view

    var post:Post?
    
    var urlString:String?
    
    var loading = false
    var timer:Timer? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    
    // Tool bar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.requestPosts { 
            self.progressView.progress  = 0
            
            self.webView.delegate = self
            
            
            self.urlString = self.post?.link?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            
//            self.titleString = self.post?.title
            let url = URL(string:self.urlString!)
            
            let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
            //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
            self.webView.loadRequest(request as URLRequest)
            
        }
        
//        progressView.progress  = 0
//        let url = NSURL(string:urlString!)
//        
//        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
//        //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
//        webView.loadRequest(request as NSURLRequest)
//        webView.delegate = self
        
        
    }
    
    
    
    
    
    @IBAction func showActivityViewController(_ sender: AnyObject) {
        
        
        //        let url = NSURL(string: urlString!)
        //        print("Test3")
        //        let activityViewController = UIActivityViewController(activityItems: [titleString!,url!], applicationActivities: nil)
        //        self.navigationController?.presentViewController(activityViewController, animated: true, completion: {
        //
        //        })
        
        
        self.rightTopBarButtonItemAction(self.post!)
    }
    
    
    
    
    
    // Web View Start Load page
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
        //        timer = NSTimer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
    }
    
    // Web View Finish Loading Page
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
            progressView.isHidden = true
            timer?.invalidate()
        }
    }
    
    
    func requestPosts(_ completionHandler:@escaping () -> Void) {
        self.startAnimating()
        client.requestTestPostsByCategories(categoryId) { (posts) in
            
            self.resourcesPosts = posts.shuffle()
            print(posts.count)
            
            self.post = self.resourcesPosts[0]
            
            completionHandler()
            
            
            
            
        }
    }
    
}
