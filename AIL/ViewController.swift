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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Search bar in Nav Bar
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
            
            return cell
        }
            
        else{
            return UICollectionViewCell()
        }
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
    
}

