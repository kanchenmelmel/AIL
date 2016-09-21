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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideMenuControllerDelegate,UISearchBarDelegate {
    
    
    var leftButtonIndex = 0

    @IBOutlet weak var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var featurePosts = [Post]()
    
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Search bar in Nav Bar

        searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), forState: .Normal)
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), forState: .Selected)
        
//        if let index = searchBar.indexofSear
        
//        setUpSearchBar()
        
        self.searchBar.barTintColor = UIColor(red: 242.0, green: 242.0, blue: 242.0, alpha: 1.0)
        self.searchBar.backgroundColor = UIColor(red: 242.0, green: 242.0, blue: 242.0, alpha: 1.0)
        self.searchBar.tintColor = UIColor(red: 68.0, green: 120.0, blue: 180.0, alpha: 1.0)
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        //let searchBarItem = UIBarButtonItem.init(customView: searchBar)
        //self.navigationItem.rightBarButtonItem = searchBarItem
        
        // Customize CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let wordpressClient = WordPressClient()
        
        wordpressClient.requestLatestTwentyPosts { (posts) in
            print("Melmel:\(posts.count)")
        }
        
        self.slideMenuController()?.delegate = self
        
        
        //The code is to be moved to PostRetriever.swift
        let postRequest = NSFetchRequest()
        postRequest.entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        
        let httpString = "http"
        let predicate = NSPredicate(format: "featuredImageUrl contains[c] %@", httpString)
        postRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.executeFetchRequest(postRequest) as! [Post]
            
            self.featurePosts = results
        }catch {
            print ("Error: Could not fetch featured Posts")
        }
        
        
    }
    
    
  
    
    override func viewDidAppear(animated: Bool) {
        self.setNavigationBarItem()
        
    
        

    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as? PostCollectionViewCell{
            cell.backgroundColor = UIColor.whiteColor()
            
            let featurePost = self.featurePosts[indexPath.row]
            
            cell.postLabel.text = featurePost.title
            
            
            if featurePost.featuredImageDownloadedToFileSys == true {
                let fileDownloader = FileDownloader()
                featurePost.featuredImage = fileDownloader.imageFromFile(featurePost.id! as Int, fileName: FEATURED_IMAGE_NAME)
                featurePost.featuredLoadingImageState = .Downloaded
                
            } else {
                if featurePost.featuredImageUrl != nil {
                    if featurePost.featuredLoadingImageState == .Downloaded {
                        
                    }
                    if featurePost.featuredLoadingImageState == .New {
                        //if (!tableView.dragging && !tableView.decelerating){
                            startOperationsForPhoto(featurePost, indexPath: indexPath)
                        //}
                    }
                    
                }
                
            }
            cell.postImage.image = featurePost.featuredImage
            
            return cell
        }
            
        else{
            return UICollectionViewCell()
        }
    }
    
    func startOperationsForPhoto(post:Post,indexPath:NSIndexPath) {
        switch (post.featuredLoadingImageState) {
        case .New:
            startDownloadFeaturedImageForPost (post:post,indexPath:indexPath)
        default: break
            //NSLog("Do nothing")
        }
    }
    
    func startDownloadFeaturedImageForPost(post post:Post,indexPath:NSIndexPath) {
//        if pendingOperations.downloadsInProgress[indexPath] != nil {
//            return
//        }
//        
//        
//            let downloader = ImageDownloader(post: post)
//        
//            downloader.completionBlock = {
//                if downloader.cancelled {
//                    return
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                    self.collectionView.reloadItemsAtIndexPaths([indexPath])
//                    post.featuredLoadingImageState = .Downloaded
//                })
//            }
//            
//            pendingOperations.downloadsInProgress[indexPath] = downloader
//            pendingOperations.downloadQueue.addOperation(downloader)
        
        
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO Goes to another view controller
    }
    

    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featurePosts.count
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
//    func leftWillOpen() {
//        
//        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
//        let messagesTableVC = storyboard.instantiateViewControllerWithIdentifier("")
//        self.navigationController?.pushViewController(messagesTableVC, animated: true)
//        self.slideMenuController()?.closeLeft()
//    }
    
    
    func setUpSearchBar() {
        var index:Int?
//        let searchBarView = self.subviews[0]
        
        for i in 0 ..< searchBar.subviews.count {
            print(i)
            if searchBar.subviews[i].isKindOfClass(UITextField) {
                index = i
                print(i)
                break
            }
        }
        
        let searchFeild = searchBar.subviews[index!] as! UITextField
        
        searchFeild.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        

    }
    
}

