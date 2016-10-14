//
//  SelTestDBTableViewController.swift
//  AIL
//
//  Created by Work on 13/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class SelTestDBTableViewController: UITableViewController {

    
    var categoryId = 0
    var resourcesPosts = [Post]()
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    
    //    let activityIndicatorView = CustomizeActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let resourceList = CoreDataOperation.fetchResourcesPostFromCoreData() {
        //            resourcesPosts = resourceList
        //        }
        //        else {
        //            print("There is someting wrong while loadding resources from Core Data")
        
        //        }
        //        self.tableView.addSubview(activityIndicatorView)
        //        activityIndicatorView.startAnimating()
        self.startAnimating()
        client.requestLatestPostsByCategories(categoryId) { (posts) in
            
            self.resourcesPosts = posts.shuffle()
            print(posts.count)
            self.tableView.reloadData()
            self.setUpTableViewImageCoordinator()
            self.stopAnimating()
        }
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resourcesPosts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubjectResourcesTableViewVell", forIndexPath: indexPath) as! SubjectResourcesTableViewCell
        
        // Configure the cell...
        cell.titleLabel.text = resourcesPosts[indexPath.row].title
        cell.subtitleLabel.text = resourcesPosts[indexPath.row].excerpt
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        cell.dateLabel.text = "\(dateFormatter.stringFromDate(resourcesPosts[indexPath.row].date!).uppercaseString)" + " "
        
        
        // Images
        print(resourcesPosts[indexPath.row].featuredImageUrl)
        if resourcesPosts[indexPath.row].featuredImageUrl != nil {
            
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
    
    
    func setUpTableViewImageCoordinator(){
        for post in resourcesPosts {
            let featuredImageUrlString = post.featuredImageUrl!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            let imageRecord = ImageRecord(name: "", url: NSURL(string: featuredImageUrlString!)!)
            self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resourcesPostWebViewSegue" {
            let destnatinationVC = segue.destinationViewController as! WebViewController
            
            let index = tableView.indexPathForSelectedRow
            destnatinationVC.post = resourcesPosts[index!.row]
            destnatinationVC.urlString = resourcesPosts[index!.row].link!
            destnatinationVC.titleString = resourcesPosts[index!.row].title!
            destnatinationVC.navigationItem.title = self.navigationItem.title
        }
    }
}
