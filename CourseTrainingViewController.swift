//
//  CourseTrainingViewController.swift
//  AIL
//
//  Created by Work on 27/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class CourseTrainingViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var segmentedControl: CustomizedSegmentedControl!
    
    // Course Info Elements
    @IBOutlet weak var timetableImageView: UIImageView!
    
    
    @IBOutlet weak var courseIntroDesLabel: UILabel!
    
    @IBOutlet weak var courseTimeLabel: UILabel!
    
    @IBOutlet weak var courseFeeLabel: UILabel!
    
    // Page control
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // Gusture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    
    
    let dayUrl = NSURL(string:DAY_CLASS_URL)
    let vipUrl = NSURL(string:VIP_CLASS_URL)
    let weekendUrl = NSURL(string:WEEKEND_CLASS_URL)
    let questionUrl = NSURL(string:QUESTION_CLASS_URL)
    
    var loading = false
    var timer:NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gesture directions
        self.swipeGestureLeft.direction = .Left
        self.swipeGestureRight.direction = .Right
        // Add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(handleGestureLeft(_:)))
            self.swipeGestureRight.addTarget(self, action: #selector(handleGestureRight(_:)))
        
        self.view.addGestureRecognizer(swipeGestureLeft)
        self.view.addGestureRecognizer(swipeGestureRight)
        
        
        self.segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), forControlEvents: .ValueChanged)
        
    
        webView.delegate = self
        
        loadWebView(weekendUrl!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        applyCSSToUIWebView(webView)
        loading = false
    }
    
    func loadWebView(url: NSURL){
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.loadRequest(request as NSURLRequest)
        
    }
    
    /// Handle gesture action swipe to left
    ///
    /// - parameter gesture:swipeGestureLeft
    func handleGestureLeft(gesture:UIGestureRecognizer) {
        if segmentedControl.selectedIndex < 2 {
            print("swipe left")
            segmentedControl.selectedIndex += 1
            segmentedControl.displayNewSelectedIndex()
            segmentedControl.sendActionsForControlEvents(.ValueChanged)
        }
        
    }
    
    /// Handle gesture action swipe to Right
    ///
    /// - parameter gesture: swipeGestureRight
    func handleGestureRight(gesture:UIGestureRecognizer) {
        if segmentedControl.selectedIndex > 0 {
            print("swipe right")
            segmentedControl.selectedIndex -= 1
            segmentedControl.displayNewSelectedIndex()
            segmentedControl.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    func segmentedValueChanged(sender:AnyObject?) {
        if segmentedControl.selectedIndex == 0 {
            loadWebView(weekendUrl!)
        }
        if segmentedControl.selectedIndex == 1 {
            loadWebView(dayUrl!)
        }
        if segmentedControl.selectedIndex == 2 {
            loadWebView(vipUrl!)
        }
        if segmentedControl.selectedIndex == 3 {
            loadWebView(questionUrl!)
        }
    }

}
