//
//  BookProcessViewController.swift
//  AIL
//
//  Created by Work on 7/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class PTETestAudioWebViewController: UIViewController, UIWebViewDelegate {
    
    var category: PTETestAudioController.Category?
    var loading = false
    var timer:Timer? = nil
    //@IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PTE真题音频"
        var kind: String
        switch category! {
            case .readAloud: kind = "ReadAloud"; break
            case .repeatSentence: kind = "RepeatSentence"; break
            case .describeImage: kind = "DescribeImage"; break
            case .writeFromDictation: kind = "WriteFromDictation"; break
            case .random: kind = "Random"; break
        }
        //let urlString = "http://127.0.0.1:8887/index.html?category=\(kind)"
        let urlString = "http://ail.vic.edu.au/PTE%E7%9C%9F%E9%A2%98%E9%9F%B3%E9%A2%91/index.html?category=\(kind)"
        let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
        //progressView.progress  = 0
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
    }
    
    /*func webViewDidStartLoad(_ webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading = false
    }*/
    
    /*func updateProgressView() {
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
    }*/

}
