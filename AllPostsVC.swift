//
//  AllPostsVC.swift
//  AIL
//
//  Created by WuKaipeng on 25/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class AllPostsVC: UITableViewController{

    
    var allPosts = [Post]()
    var isLoading = false
    var numOfPosts:Int?
    var reachToTheEnd = false
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//<<<<<<< HEAD
//        allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
//        
//        if allPosts.count <= 0 {
//            client.requestLatestTwentyPosts { (posts) in
//                
//                self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
//                self.tableView.reloadData()
//                self.setUpTableViewImageCoordinator()
//            }
//        }
//        else{
//=======
        
        
       
        client.requestLatestTwentyPosts { (posts) in
            
            self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
//>>>>>>> master
            self.tableView.reloadData()
            self.setUpTableViewImageCoordinator()
        }
       
        

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Initialize the refresh control
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(AllPostsVC.updatePosts), forControlEvents: .ValueChanged)
        refresher.backgroundColor = UIColor.clearColor()
        refresher.tintColor = hexStringToUIColor("#00B2EE")
       // refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.tableView.addSubview(refresher)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print ("visiblePaths: \(tableView.indexPathsForVisibleRows)")
        
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func setUpTableViewImageCoordinator(){
        //self.tableViewImageLoadingCoordinator.imageRecords.removeAll()
        for post in allPosts {
            if let imageURL = post.featuredImageUrl{
                let imageRecord = ImageRecord(name: "", url: NSURL(string: imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
                self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == allPosts.count-1) && !isLoading{
            isLoading = true
            
            if reachToTheEnd == false {
                numOfPosts = allPosts.count
                print ("num1:\(numOfPosts)")
                let oldestPost = allPosts[indexPath.row]

                client.requestPreviousPosts(oldestPost.date!, excludeID: oldestPost.id as! Int, completionHandler: { (posts) in
                        self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
                        print ("num2:\(self.numOfPosts)")
                        print ("num3: \(self.allPosts.count)")
                        if self.numOfPosts == self.allPosts.count{
                            self.reachToTheEnd = true
                            print ("pppTRUE")
                        }
                        for post in posts {
                            print ("ppp: \(post.featuredImageUrl)")
                            if let imageURL = post.featuredImageUrl{
                                print("pppnn")
                                let imageRecord = ImageRecord(name: "", url: NSURL(string: imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
                                self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
                            }
                        }
                        //self.setUpTableViewImageCoordinator()
                        self.isLoading = false
                        self.tableView.reloadData()
                })
        }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllPostsCell", forIndexPath: indexPath) as! AllPostsCell
        
        // Configure the cell...
        let post = allPosts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.subtitleLabel.text = post.excerpt
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        cell.dateLabel.text = "\(dateFormatter.stringFromDate(post.date!).uppercaseString)" + " "
        
        
        // Images
      
        if post.featuredImageUrl != nil {
            
            let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row]
            cell.cellImageView.image = imageRecord.image
            print(imageRecord.image)
            
            switch (imageRecord.state) {
            case .New, .Downloaded:
                if (!tableView.dragging && !tableView.decelerating){
                    self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    })
                }
            default:
                print("Do Nothing for loading cell image \(indexPath.row)")
            }
            
            
        }
        
        
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.tableViewImageLoadingCoordinator.suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            
           
            
            self.tableViewImageLoadingCoordinator.loadImagesForOnScreenCells(tableView.indexPathsForVisibleRows!, completionhandler: { (indexPath) in
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            self.tableViewImageLoadingCoordinator.resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.tableViewImageLoadingCoordinator.loadImagesForOnScreenCells(tableView.indexPathsForVisibleRows!, completionhandler: { (indexPath) in
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        })
        
        self.tableViewImageLoadingCoordinator.resumeAllOperations()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webviewController" {
            let destnatinationVC = segue.destinationViewController as! WebViewController
            
            let index = tableView.indexPathForSelectedRow
            
            destnatinationVC.post = allPosts[index!.row]
            
            
            destnatinationVC.urlString = allPosts[index!.row].link!
            destnatinationVC.titleString = allPosts[index!.row].title!
        }
    }
    
    func updatePosts(){
        client.requestLatestTwentyPosts { (posts) in
            self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
            let reversedPosts = posts.reverse()
            for post in reversedPosts {
                if let imageURL = post.featuredImageUrl{
                    let imageRecord = ImageRecord(name: "", url: NSURL(string: imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
                    self.tableViewImageLoadingCoordinator.imageRecords.insert(imageRecord, atIndex: 0)
                    
                }
            }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        print ("updateposts")
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
