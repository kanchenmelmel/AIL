//
//  PTELiveForumWebViewController.swift
//  AIL
//
//  Created by Work on 11/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class PTELiveForumWebViewController: UIViewController,UIWebViewDelegate {

    var post:Post?
    
    var urlString:String?
    var titleString:String?
    
    var loading = false
    var timer:Timer? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    
    // Tool bar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        urlString = "http://ail.vic.edu.au/live/"
        
        progressView.progress  = 0
        let url = URL(string:urlString!)
        
        let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
        //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
        post = CoreDataOperation.buildRandomPost(0, title: "PTE考试直播论坛", excerpt: "PTE考试直播论坛", date: Date(), link: urlString!)
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
    @IBAction func activityButtonClick(_ sender: AnyObject) {
        if post != nil {
            self.rightTopBarButtonItemAction(post!)
        }
    }


}
