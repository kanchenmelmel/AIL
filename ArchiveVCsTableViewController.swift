//
//  ArchiveVCsTableViewController.swift
//  AIL
//
//  Created by Work on 2/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class ArchiveVCsTableViewController: UITableViewController {

    var archives = [Archive]()
    
    //let tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        archives = CoreDataOperation.fetchAllArchivesFromCoreData()!
        self.tableView.reloadData()
    }

    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if archives.count == 0 {
            return 1
        }
        return archives.count
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if archives.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "noPostCell",for: indexPath)
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as! UserMessageCell
        
        let archive = archives[indexPath.row]
        
        // Configure the cell...
        cell.titleLbael.text = archive.postTitle
        cell.subtitleLabel.text = archive.excerpt
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = "\(dateFormatter.string(from: archive.archiveDate! as Date).uppercased())" + " "
        
        //var messageIcon: UIImage?
//        if archive.viewed == true {
//            messageIcon = UIImage(named: "Read")
//        }
//        else{
//            messageIcon = UIImage(named: "Unread")
//        }
        //cell.imageView?.image = messageIcon
        
        
        return cell
    }
    
    
    
    // Swipe to delete 
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if archives.count == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let archive = archives[indexPath.row]
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            CoreDataOperation.deleteManagedObjectFromCoreData(archive)
            
            archives.remove(at: indexPath.row)
            if archives.count != 0 {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.reloadData()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showArchiveWebVCSegue" {
            let destinationVC = segue.destination as! ArchiveWebViewController
            
            let index = self.tableView.indexPathForSelectedRow
            let archive = archives[index!.row]
            destinationVC.urlString = archive.link
        }
    }
 
 

}
