//
//  ResourceWebViewController.swift
//  AIL
//
//  Created by Work on 22/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var urlString:String?
    var titleString:String?
    
    var loading = false
    var timer:NSTimer? = nil

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        progressView.progress  = 0
        let url = NSURL(string:urlString!)
        
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
//        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.loadRequest(request as NSURLRequest)
        webView.delegate = self
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func showActivityViewController(sender: AnyObject) {
        
        let url = NSURL(string: urlString!)
        print("Test3")
        let activityViewController = UIActivityViewController(activityItems: [titleString!,url!], applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: { 
            
        })
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
