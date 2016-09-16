//
//  ViewController.swift
//  AIL
//
//  Created by Work on 1/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
// test

import UIKit
import SlideMenuControllerSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideMenuControllerDelegate {
    
    
    var leftButtonIndex = 0

    @IBOutlet weak var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Search bar in Nav Bar
        self.navigationItem.titleView = searchBar
        //let searchBarItem = UIBarButtonItem.init(customView: searchBar)
        //self.navigationItem.rightBarButtonItem = searchBarItem
        
        // Customize CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let wordpressClient = WordPressClient()
        
        wordpressClient.requestLatestTwentyPosts { (posts) in
            print(posts.count)
        }
        
        self.slideMenuController()?.delegate = self
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.setNavigationBarItem()
        
    
        

    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as? PostCollectionViewCell{
            cell.backgroundColor = UIColor.whiteColor()
            //cell.postLabel.textColor = UIColor.lightGrayColor()
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
        return 10
    }
    
    
//    func leftWillOpen() {
//        
//        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
//        let messagesTableVC = storyboard.instantiateViewControllerWithIdentifier("")
//        self.navigationController?.pushViewController(messagesTableVC, animated: true)
//        self.slideMenuController()?.closeLeft()
//    }
    
}

