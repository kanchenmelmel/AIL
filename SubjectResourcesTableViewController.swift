//
//  SubjectResourcesTableViewController.swift
//  AIL
//
//  Created by Work on 13/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


func imageURL(_ featuredImageURLString: String?) -> URL {
    if featuredImageURLString != nil {
        let url = URL(string: featuredImageURLString!)
        if url != nil {
            return url!
        }
    }
    return URL(string: "http://ail.vic.edu.au/wp-content/uploads/2016/05/29-banner.jpg")!
}


class SubjectResourcesTableViewController: UITableViewController, NVActivityIndicatorViewable {
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
        client.requestLatestPostsByCategories(159) { (posts) in
            
            self.resourcesPosts = posts
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resourcesPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectResourcesTableViewVell", for: indexPath) as! SubjectResourcesTableViewCell

        // Configure the cell...
        cell.titleLabel.text = resourcesPosts[indexPath.row].title
        cell.subtitleLabel.text = resourcesPosts[indexPath.row].excerpt
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = "\(dateFormatter.string(from: resourcesPosts[indexPath.row].date! as Date).uppercased())" + " "
        
        
        // Images
        print(resourcesPosts[indexPath.row].featuredImageUrl as Any)
        if resourcesPosts[indexPath.row].featuredImageUrl != nil {
            
            let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row]
            cell.cellImageView.image = imageRecord.image
            print(imageRecord.image as Any)
            
            switch (imageRecord.state) {
            case .new, .downloaded:
                
                if (!tableView.isDragging && !tableView.isDecelerating){
                    self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    })
                }
            default:
                print("Do Nothing for loading cell image \(indexPath.row)")
            }
            
            
        }
        
        
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableViewImageLoadingCoordinator.suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            
            
            
            self.tableViewImageLoadingCoordinator.loadImagesForOnScreenCells(tableView.indexPathsForVisibleRows!, completionhandler: { (indexPath) in
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
            self.tableViewImageLoadingCoordinator.resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tableViewImageLoadingCoordinator.loadImagesForOnScreenCells(tableView.indexPathsForVisibleRows!, completionhandler: { (indexPath) in
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        })
        
        self.tableViewImageLoadingCoordinator.resumeAllOperations()
    }

    
    func setUpTableViewImageCoordinator(){
        for post in resourcesPosts {
            
            let featuredImageURLString = post.featuredImageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            //let imageRecord = ImageRecord(name: "", url: URL(string: featuredImageURLString!)!)
            let imageRecord = ImageRecord(name: "", url: imageURL(featuredImageURLString))
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
            destnatinationVC.post = resourcesPosts[index!.row]
            destnatinationVC.urlString = resourcesPosts[index!.row].link!
            destnatinationVC.titleString = resourcesPosts[index!.row].title!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAnimating()
    }


}
