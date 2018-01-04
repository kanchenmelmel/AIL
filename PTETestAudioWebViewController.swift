//
//  BookProcessViewController.swift
//  AIL
//
//  Created by Work on 7/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

let DEBUG = false
let VIDEO_URL = DEBUG ? "http://localhost:8888/wordpress/pte/videos.php" : "http://ail.vic.edu.au/PTE%E7%9C%9F%E9%A2%98%E9%9F%B3%E9%A2%91/videos.php";


class PTETestAudioWebViewController: UIViewController, UIWebViewDelegate {
    
    var category: PTETestAudioController.Category?
    var loading = false
    var timer:Timer? = nil
    //@IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = category == .videoLectures ? "PTE视频课程" : "PTE真题音频"
        
        webView.delegate = self
        webView.allowsInlineMediaPlayback = false
        
        let path = Bundle.main.path(forResource: category != .videoLectures ? "audios" : "videos", ofType: "html", inDirectory: "www")!
        webView.loadRequest(URLRequest(url: URL(fileURLWithPath: path)))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (category != .videoLectures) {
            // Set category for audios
            var kind: String
            switch category! {
                case .readAloud: kind = "ReadAloud"
                case .repeatSentence: kind = "RepeatSentence"
                case .describeImage: kind = "DescribeImage"
                case .writeFromDictation: kind = "WriteFromDictation"
                case .retellLecture: kind = "RetellLecture"
                case .summariseSpokenText: kind = "SummariseSpokenText"
                case .random: kind = "Random"
                case .videoLectures: kind = ""
            }
            webView.stringByEvaluatingJavaScript(from: "window.CATEGORY = \"\(kind)\";");
        } else {
            if (WPClient.authorized) {
                webView.stringByEvaluatingJavaScript(from: "window.USER_ID = \(WPClient.me!["id"]!);")
            }
        }
    }

}
