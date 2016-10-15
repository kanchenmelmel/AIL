//
//  JiJingDBViewController.swift
//  AIL
//
//  Created by Work on 12/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class JiJingDBViewController: UIViewController,UIWebViewDelegate {

    var post:Post?
    
    var urlString:String?
    var titleString:String?
    
    var loading = false
    var timer:NSTimer? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    
    // Tool bar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        urlString = "http://ail.vic.edu.au/download/"
        
        progressView.progress  = 0
        let url = NSURL(string:urlString!)
        
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.loadRequest(request as NSURLRequest)
        webView.delegate = self
        post = CoreDataOperation.buildRandomPost(0, title: "机经题库", excerpt: "机经题库", date: NSDate(), link: urlString!)
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
    @IBAction func activityButtonClick(sender: AnyObject) {
        if post != nil {
            self.rightTopBarButtonItemAction(post!)
        }
    }

}
