//
//  AllPostsVC.swift
//  AIL
//
//  Created by WuKaipeng on 25/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AllPostsVC: UITableViewController, NVActivityIndicatorViewable {

    
    var allPosts = [Post]()
    var isLoading = false
    var numOfPosts:Int?
    var reachToTheEnd = false
    
    var tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    
    var refresher: UIRefreshControl!
    
    
//    let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2.0 - 50,UIScreen.mainScreen().bounds.height/2.0 - 50,100.0,100.0), type: .BallPulse, color: UIColor.tintColor(), padding: 10.0)
    
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
        
        
//        self.tableView.addSubview(activityIndicatorView)
        startAnimating()
        client.requestLatestTwentyPosts { (posts) in
            
            self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
//>>>>>>> master
            self.tableView.reloadData()
            self.setUpTableViewImageCoordinator()
            self.stopAnimating()
        }
       
        

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Initialize the refresh control
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(AllPostsVC.updatePosts), for: .valueChanged)
        refresher.backgroundColor = UIColor.clear
        refresher.tintColor = hexStringToUIColor("#00B2EE")
       // refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.tableView.addSubview(refresher)
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
        //print ("visiblePaths: \(String(describing: tableView.indexPathsForVisibleRows))")
        
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func setUpTableViewImageCoordinator(){
        //self.tableViewImageLoadingCoordinator.imageRecords.removeAll()
        for post in allPosts {
            if var imageURL = post.featuredImageUrl {
                if imageURL == "" {
                    imageURL = "http://ail.vic.edu.au/wp-content/uploads/2016/09/book-1628732_1280.jpg"
                }
                let imageRecord = ImageRecord(name: "", url: URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
                self.tableViewImageLoadingCoordinator.imageRecords.append(imageRecord)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == allPosts.count-1) && !isLoading{
            isLoading = true
            
            if reachToTheEnd == false {
                numOfPosts = allPosts.count
                //print ("num1:\(String(describing: numOfPosts))")
                let oldestPost = allPosts[indexPath.row]

                client.requestPreviousPosts(oldestPost.date!, excludeID: oldestPost.id as! Int, completionHandler: { (posts) in
                        self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
                        //print ("num2:\(String(describing: self.numOfPosts))")
                        //print ("num3: \(self.allPosts.count)")
                        if self.numOfPosts == self.allPosts.count{
                            self.reachToTheEnd = true
                            //print ("pppTRUE")
                        }
                        for post in posts {
                            //print ("ppp: \(String(describing: post.featuredImageUrl))")
                            if var imageURL = post.featuredImageUrl {
                                //print("pppnn")
                                if imageURL == "" {
                                    imageURL = "http://ail.vic.edu.au/wp-content/uploads/2016/09/book-1628732_1280.jpg"
                                }
                                let imageRecord = ImageRecord(name: "", url: URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 271
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPostsCell", for: indexPath) as! AllPostsCell
        
        // Configure the cell...
    
        let post = allPosts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.subtitleLabel.text = post.excerpt
    
        

        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .MediumStyle
//        cell.dateLabel.text = "\(dateFormatter.stringFromDate(post.date!).uppercaseString)" + " "
//        
//        
        // Images
      
        if post.featuredImageUrl != nil {
            
            let imageRecord = self.tableViewImageLoadingCoordinator.imageRecords[indexPath.row]
            cell.cellImageView.image = imageRecord.image
            //print(imageRecord.image as Any)
            
            switch (imageRecord.state) {
            case .new, .downloaded:
                if (!tableView.isDragging && !tableView.isDecelerating){
                    self.tableViewImageLoadingCoordinator.startOperationsForImageRecord(imageRecord, indexPath: indexPath, completionhandler: {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    })
                }
            default: break
                //print("Do Nothing for loading cell image \(indexPath.row)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webviewController" {
            let destnatinationVC = segue.destination as! WebViewController
            
            let index = tableView.indexPathForSelectedRow
            
            destnatinationVC.post = allPosts[index!.row]
            
            
            destnatinationVC.urlString = allPosts[index!.row].link!
            destnatinationVC.titleString = allPosts[index!.row].title!
        }
    }
    
    func updatePosts(){
        client.requestLatestTwentyPosts { (posts) in
            self.allPosts = CoreDataOperation.fetchResourcesPostFromCoreData()!
            let reversedPosts = posts.reversed()
            for post in reversedPosts {
                if let imageURL = post.featuredImageUrl{
                    let imageRecord = ImageRecord(name: "", url: URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
                    self.tableViewImageLoadingCoordinator.imageRecords.insert(imageRecord, at: 0)
                    
                }
            }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        //print ("updateposts")
        
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
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
