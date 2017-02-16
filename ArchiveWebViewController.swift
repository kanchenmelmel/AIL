//
//  ArchiveWebViewController.swift
//  AIL
//
//  Created by Work on 3/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class ArchiveWebViewController: UIViewController,UIWebViewDelegate {
    
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
        
        progressView.progress  = 0
        let url = URL(string:urlString!)
        
        let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
        //        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
