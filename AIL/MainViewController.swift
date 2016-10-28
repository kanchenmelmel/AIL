//
//  ViewController.swift
//  AIL
//
//  Created by Work on 1/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
// test

import UIKit
import SlideMenuControllerSwift
import CoreData
import EAIntroView

class ViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideMenuControllerDelegate,UISearchBarDelegate {
    
    
    
    var introView:EAIntroView?
    var rootView:UIView?
    
    var leftButtonIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController()
    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var featurePosts = [Post]()
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    let wordpressClient = WordPressClient()
    let postRetriever = PostRetriever()
    
    let alert = Alert()
    
    var timer:NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        // Setup Search bar in Nav Bar
        
        
        //        self.setNavigationBarItem()
        //        let searchBar = searchController.searchBar
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), forState: .Normal)
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), forState: .Selected)
        
        //        if let index = searchBar.indexofSear
        
        //        setUpSearchBar()
        
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        //        self.searchBar.backgroundColor = UIColor(red: 242.0, green: 242.0, blue: 242.0, alpha: 1.0)
        //        self.searchBar.tintColor = UIColor(red: 68.0, green: 120.0, blue: 180.0, alpha: 1.0)
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        //let searchBarItem = UIBarButtonItem.init(customView: searchBar)
        //self.navigationItem.rightBarButtonItem = searchBarItem
        
        // Customize CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.slideMenuController()?.delegate = self
        
        
        
        featurePosts = postRetriever.fetchPosts()
        
        if featurePosts.count <= 0 {
            wordpressClient.requestLatestTwentyPosts { (posts) in
                
                self.featurePosts = self.postRetriever.fetchPosts()
                //                self.createLastPost()
                self.collectionView.reloadData()
                self.setUpTableViewImageCoordinator()
            }
        }
        else{
            //            createLastPost()
            self.collectionView.reloadData()
            self.setUpTableViewImageCoordinator()
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasSeenIntroduction") {
            self.setupIntroPages()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenIntroduction")
        }
        
        
        
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        //        self.setNavigationBarItem()
        
        
        
        
    }
    
    //    func createLastPost() -> Void{
    //        //create last post
    //        let postDescription = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
    //        let lastPost = Post(entity: postDescription!, insertIntoManagedObjectContext: nil)
    //
    //        lastPost.featuredImage = UIImage(named: "AllPostsButton")
    //        lastPost.title = "点击阅读更多资讯"
    //        lastPost.featuredImageUrl = nil
    //
    //        featurePosts.append(lastPost)
    //
    //    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("PTELiveCell", forIndexPath: indexPath) as! LastCollectionViewCell
        } else if indexPath.row <= self.featurePosts.count {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as? PostCollectionViewCell{
                cell.backgroundColor = UIColor.whiteColor()
                
                print ("123123: \(self.featurePosts.count)")
                
                let featurePost = self.featurePosts[indexPath.row - 1]
                
                cell.postLabel.text = featurePost.title
                
                
                if featurePost.featuredImageUrl != nil {
                    
                    cell.postImage.contentMode = .ScaleAspectFill
                    
                    let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row - 1]
                    cell.postImage.image = imageRecord.image
                    
                    switch (imageRecord.state) {
                    case .New, .Downloaded:
                        
                        self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                            // self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            self.collectionView.reloadItemsAtIndexPaths([indexPath])
                        })
                    default:
                        print("Do Nothing for loading cell image \(indexPath.row - 1)")
                    }
                    
                    
                }
                else{
                    
                    cell.postImage.contentMode = .ScaleAspectFit
                    cell.postImage.image = featurePost.featuredImage
                    
                }
                
                return cell
            }
                
            else{
                return UICollectionViewCell()
            }
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("allPostCell", forIndexPath: indexPath) as! LastCollectionViewCell
        }
    }
    
    func setUpTableViewImageCoordinator(){
        for post in featurePosts {
            if post.featuredImageUrl != nil{
                let featuredImageURLString = post.featuredImageUrl!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
                let imageRecord = ImageRecord(name: "", url: NSURL(string: featuredImageURLString!)!)
                self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO Goes to another view controller
        if indexPath.row == featurePosts.count + 1 {
            self.performSegueWithIdentifier("allPostVC", sender: nil)
        }
        else if indexPath.row != 0{
            let featurePost = featurePosts[indexPath.row - 1]
            
            self.performSegueWithIdentifier("showPostWebViewSegue", sender: featurePost)
        }
        
    }
    
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featurePosts.count + 2
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAboutAILVC" {
            let destinationVC = segue.destinationViewController as! AboutAILViewController
            destinationVC.showLeftPanelButton = false
        }
        
        if segue.identifier == "showPostWebViewSegue" {
            // let cellIndex = collectionView.indexPathsForSelectedItems()![0]
            
            //let selectedPost = featurePosts[cellIndex.row]
            
            if let selectedPost = sender as? Post{
                
                let destinationVC = segue.destinationViewController as! WebViewController
                destinationVC.post = selectedPost
                destinationVC.urlString = selectedPost.link
                destinationVC.titleString = selectedPost.title
            }
        }
    }
    
    func setupIntroPages() {
        let page1 = EAIntroPage(customViewFromNibNamed: "IntroPage1View")
        let page2 = EAIntroPage(customViewFromNibNamed: "IntroPage2View")
        let page3 = EAIntroPage(customViewFromNibNamed: "IntroPage3View")
        
        
        rootView = self.navigationController?.view
        introView = EAIntroView(frame: rootView!.bounds, andPages: [page1,page2,page3])
        
        let startButton = page3.pageView.viewWithTag(1) as! UIButton
        
        startButton.addTarget(self, action: #selector(buttonClicked), forControlEvents: .TouchUpInside)
        
       // UIButton startButton = page3.pageView.viewWithTag(1)
        introView!.skipButton.alpha = 0
        introView!.skipButton.enabled = false
        introView!.tapToNext = true
        introView!.showInView(rootView, animateDuration: 0.3)
    }
    
    func buttonClicked(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(self.introAnimation), userInfo: nil, repeats: true)
    
        //self.introView?.removeFromSuperview()
        
        
    }
    
    func introAnimation (){
        if self.introView?.alpha > 0.2 {
            self.introView?.alpha -= 0.1
        }else{
            self.introView?.removeFromSuperview()
            timer?.invalidate()
        }
        
        
    }
    
    
    
    
    
}

