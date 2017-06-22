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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideMenuControllerDelegate,UISearchBarDelegate {
    
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var speechRecognitionButton: UIView!
    @IBOutlet weak var jiJingButton: UIButton!
    var introView:EAIntroView?
    var rootView:UIView?
    
    
    var leftButtonIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController()
    
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var featurePosts = [Post]()
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    let wordpressClient = WordPressClient()
    let postRetriever = PostRetriever()
    
    let alert = Alert()
    
    var timer:Timer? = nil
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.height / 2.0;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        // Setup Search bar in Nav Bar
        
        
        //        self.setNavigationBarItem()
        //        let searchBar = searchController.searchBar
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), for: UIControlState())
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchTextFieldBK"), for: .selected)
        
        //        if let index = searchBar.indexofSear
        
        //        setUpSearchBar()
        
        searchController.searchBar.barTintColor = UIColor.white
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
        
        if !UserDefaults.standard.bool(forKey: "hasSeenIntroduction") {
            self.setupIntroPages()
            UserDefaults.standard.set(true, forKey: "hasSeenIntroduction")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "PTELiveCell", for: indexPath) as! LastCollectionViewCell
        } else if indexPath.row == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "PTEExchangeCell", for: indexPath) as! LastCollectionViewCell
        } else if indexPath.row <= self.featurePosts.count + 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCollectionViewCell {
                cell.backgroundColor = UIColor.white
                
                //print ("123123: \(self.featurePosts.count)")
                
                let featurePost = self.featurePosts[indexPath.row - 2]
                
                cell.postLabel.text = featurePost.title
                
                
                if featurePost.featuredImageUrl != nil {
                    
                    cell.postImage.contentMode = .scaleAspectFill
                    
                    let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row - 2]
                    cell.postImage.image = imageRecord.image
                    
                    switch (imageRecord.state) {
                    case .new, .downloaded:
                        
                        self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                            // self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            self.collectionView.reloadItems(at: [indexPath])
                        })
                    default: break
                        //print("Do Nothing for loading cell image \(indexPath.row - 2)")
                    }
                    
                    
                }
                else{
                    
                    cell.postImage.contentMode = .scaleAspectFit
                    cell.postImage.image = featurePost.featuredImage
                    
                }
                
                return cell
            }
                
            else{
                return UICollectionViewCell()
            }
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "allPostCell", for: indexPath) as! LastCollectionViewCell
        }
    }
    
    func setUpTableViewImageCoordinator(){
        for post in featurePosts {
            if post.featuredImageUrl != nil{
                let featuredImageURLString = post.featuredImageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                let imageRecord = ImageRecord(name: "", url: imageURL(featuredImageURLString))
                self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO Goes to another view controller
        if indexPath.row == featurePosts.count + 2 {
            self.performSegue(withIdentifier: "allPostVC", sender: nil)
        } else if indexPath.row > 1 {
            let featurePost = featurePosts[indexPath.row - 1]
            self.performSegue(withIdentifier: "showPostWebViewSegue", sender: featurePost)
        } else if indexPath.row == 1 {
            //print("==2==2==2==2==2==2==2==")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: collectionView.frame.height - 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -56, left: 8, bottom: 8, right: 8)
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.featurePosts.count + 3
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAboutAILVC" {
            let destinationVC = segue.destination as! AboutAILViewController
            destinationVC.showLeftPanelButton = false
        }
        
        if segue.identifier == "showPostWebViewSegue" {
            // let cellIndex = collectionView.indexPathsForSelectedItems()![0]
            
            //let selectedPost = featurePosts[cellIndex.row]
            
            if let selectedPost = sender as? Post{
                
                let destinationVC = segue.destination as! WebViewController
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
        introView = EAIntroView(frame: rootView!.bounds, andPages: [page1 as Any,page2 as Any,page3 as Any])
        
        let startButton = page3?.pageView.viewWithTag(1) as! UIButton
        
        startButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
       // UIButton startButton = page3.pageView.viewWithTag(1)
        introView!.skipButton.alpha = 0
        introView!.skipButton.isEnabled = false
        introView!.tapToNext = true
        introView!.show(in: rootView, animateDuration: 0.3)
    }
    
    func buttonClicked(){
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.introAnimation), userInfo: nil, repeats: true)
    
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

