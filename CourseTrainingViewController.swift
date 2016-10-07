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
    private var pageViewController:UIPageViewController?
    
    
//    @IBOutlet weak var courseIntroDesLabel: UILabel!
//    
//    @IBOutlet weak var courseTimeLabel: UILabel!
//    
//    @IBOutlet weak var courseFeeLabel: UILabel!
//    
//    // Page control
//    
//    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // Gusture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    var controllers = [CourseWebViewController]()
    var thePage = CourseWebViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Setup gesture directions
        //self.swipeGestureLeft.direction = .Left
        //self.swipeGestureRight.direction = .Right
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
            //self.courseIntroDesLabel.text = "1"
            getItemController(0)
        }
        if segmentedControl.selectedIndex == 1 {
            //self.courseIntroDesLabel.text = "2"
            getItemController(1)
        }
        if segmentedControl.selectedIndex == 2 {
            //self.courseIntroDesLabel.text = "3"
            getItemController(2)
        }
    }
    
    func createPageViewController(){
        self.pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageControl") as! UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        var firstController = getItemController(thePage.itemIndex)!
        var startingViewControllers = [firstController]
        pageViewController!.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        //pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
    }
    
    
    func getItemController(itemIndex: Int) -> UIViewController? {
        var vc: CourseWebViewController? = nil
        switch itemIndex {
        case 0:
            vc = self.storyboard!.instantiateViewControllerWithIdentifier("CourseWebViewController") as! CourseWebViewController
            vc?.itemIndex = itemIndex
            vc?.urlString = "http://ail.vic.edu.au"
            
            
        case 1:
            vc = self.storyboard!.instantiateViewControllerWithIdentifier("CourseWebViewController") as! CourseWebViewController
            vc?.itemIndex = itemIndex
            
            
        case 2:
            vc = self.storyboard!.instantiateViewControllerWithIdentifier("CourseWebViewController") as! CourseWebViewController
            vc?.itemIndex = itemIndex
            
        default:
            return nil
            
        }
        return vc
    }

}

extension CourseTrainingViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate, UINavigationControllerDelegate{
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! CourseWebViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CourseWebViewController
        
        if itemController.itemIndex+1 < 3 {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
//    func pageViewController(photoPageViewController: UIPageViewController,
//                            didFinishAnimating finished: Bool,
//                                               previousViewControllers pageViewController: [AnyObject],
//                                                                       transitionCompleted completed: Bool)
//    {
//        if (!completed)
//        {
//            
//            return;
//        }
//        
//        segmentedControl.selectedSegmentIndex = thePageIndex 
//        //thePageIndex is a global variable that changes when views from pageViewController appear
//        
//    }

}
