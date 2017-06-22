//
//  TestDBTableViewController.swift
//  AIL
//
//  Created by Work on 26/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BeiKaoGongLueTableViewController: UITableViewController, NVActivityIndicatorViewable {

    var posts = [Post]()
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    
//    let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2.0 - 50,UIScreen.mainScreen().bounds.height/2.0 - 50,100.0,100.0), type: .BallPulse, color: UIColor.tintColor(), padding: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let resourceList = CoreDataOperation.fetchResourcesPostFromCoreData() {
        //            resourcesPosts = resourceList
        //        }
        //        else {
        //            print("There is someting wrong while loadding resources from Core Data")
        //        }
        
//        self.tableView.addSubview(activityIndicatorView)
        
        startAnimating()
        
        client.requestLatestPostsByCategories(166, completionHandler: { (posts) in
            self.posts = posts
            //print(posts.count)
            self.tableView.reloadData()
            self.stopAnimating()
            self.setUpTableViewImageCoordinator()
        })
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestDBTableViewCell", for: indexPath) as! SubjectResourcesTableViewCell
        
        // Configure the cell...
        cell.titleLabel.text = posts[indexPath.row].title
        cell.subtitleLabel.text = posts[indexPath.row].excerpt
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = "\(dateFormatter.string(from: posts[indexPath.row].date! as Date).uppercased())" + " "
        
        
        // Images
        //print(posts[indexPath.row].featuredImageUrl as Any)
        if posts[indexPath.row].featuredImageUrl != nil {
            
            let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row]
            cell.cellImageView.image = imageRecord.image
            //print(imageRecord.image)
            
            switch (imageRecord.state) {
            case .new, .downloaded:
                
                self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                })
            default: break
                //print("Do Nothing for loading cell image \(indexPath.row)")
            }
            
            
        }
        
        
        
        return cell
    }
    
    func setUpTableViewImageCoordinator(){
        for post in posts {
            NSLog("\(String(describing: post.featuredImageUrl))")
            
            let imageUrlString = post.featuredImageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let imageRecord = ImageRecord(name: "", url: URL(string: imageUrlString!)!)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resourcesPostWebViewSegue" {
            let destnatinationVC = segue.destination as! WebViewController
            
            let index = tableView.indexPathForSelectedRow
            destnatinationVC.post = posts[index!.row]
            destnatinationVC.urlString = posts[index!.row].link!
            destnatinationVC.titleString = posts[index!.row].title!
        }
    }

}
