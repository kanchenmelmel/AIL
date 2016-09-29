//
//  CourseTrainingViewController.swift
//  AIL
//
//  Created by Work on 27/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class CourseTrainingViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
            self.courseIntroDesLabel.text = "1"
        }
        if segmentedControl.selectedIndex == 1 {
            self.courseIntroDesLabel.text = "2"
        }
        if segmentedControl.selectedIndex == 2 {
            self.courseIntroDesLabel.text = "3"
        }
    }

}
