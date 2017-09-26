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
        if (category != .videoLectures) {
            var kind: String
            switch category! {
            case .readAloud: kind = "ReadAloud"; break
            case .repeatSentence: kind = "RepeatSentence"; break
            case .describeImage: kind = "DescribeImage"; break
            case .writeFromDictation: kind = "WriteFromDictation"; break
            case .retellLecture: kind = "RetellLecture"; break
            case .summariseSpokenText: kind = "SummariseSpokenText"; break
            case .random: kind = "Random"; break
            case .videoLectures: kind = ""; break
            }
            let urlString = "http://ail.vic.edu.au/PTE%E7%9C%9F%E9%A2%98%E9%9F%B3%E9%A2%91/index.html?category=\(kind)"
            let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
            webView.loadRequest(request as URLRequest)
        } else {
            if (WPClient.authorized) {
                WPClient.user(id: WPClient.me!["id"] as! Int) { user in
                    let roles = user!["roles"] as! [String]
                    let rolesQuery = roles.map { "roles[]=" + $0 }.joined(separator: "&")
                    let urlString = "\(VIDEO_URL)?\(rolesQuery)"
                    let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
                    self.webView.loadRequest(request as URLRequest)
                }
            } else {
                let alert = UIAlertController(title: "未登录", message: "未登录用户仅能查看免费视频", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确认", style: .cancel))
                self.present(alert, animated:true)
            
                let urlString = "\(VIDEO_URL)?roles[]=subscriber"
                let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
                webView.loadRequest(request as URLRequest)
            }
        }
        webView.delegate = self
    }

}
