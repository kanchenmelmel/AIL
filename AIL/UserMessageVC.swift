//
//  TableViewController.swift
//  AIL
//
//  Created by WuKaipeng on 14/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UserMessageVC: UITableViewController {

    
    var userMessages = [Message]()
    
    //let tableViewImageLoadingCoordinator = TableViewImageLoadingCoordinator()
    
    let client = WordPressClient()
    
    var isLoading = false
    var numOfMessages:Int?
    var reachToTheEnd = false
    //var refresher: UIRefreshControl!
    
    
//    let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2.0 - 50,UIScreen.mainScreen().bounds.height/2.0 - 50,100.0,100.0), type: .BallPulse, color: UIColor.tintColor(), padding: 10.0)
//    let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height), type: .BallPulse, color: UIColor.tintColor(), padding: 10.0)
//    let activityIndicatorView = CustomizeActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
//       self.tableView.addSubview(activityIndicatorView)
        
        
        //activityIndicatorView.backgroundColor = UIColor.whiteColor()
        
//        activityIndicatorView.startAnimating()
        startAnimating(CGSizeMake(50, 50), message: "Loading", type: .BallPulse, color: UIColor.tintColor(), padding: 0)
        client.requestAllMessages { (messages) in
            
            print ("abc: \(messages.count)")
            self.userMessages = CoreDataOperation.fetchAllMessagesFromCoreData()!
          
            self.tableView.reloadData()
            self.stopAnimating()
//            self.activityIndicatorView.stopAnimating()
        }
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.clearColor()
        self.refreshControl!.tintColor = hexStringToUIColor("#00B2EE")
        self.refreshControl!.addTarget(self, action: #selector(self.updateMessages), forControlEvents: .ValueChanged)
        
    }
    override func viewDidAppear(animated: Bool) {
        // Initialize the refresh control
//        refresher = UIRefreshControl()
//        refresher.addTarget(self, action: #selector(self.updateMessages), forControlEvents: .ValueChanged)
//        refresher.backgroundColor = UIColor.clearColor()
//        refresher.tintColor = hexStringToUIColor("#00B2EE")
//        self.tableView.addSubview(refresher)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userMessages.count
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//<<<<<<< HEAD
    
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
    
//=======
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == userMessages.count-1) && !isLoading{
            isLoading = true
            
            if reachToTheEnd == false {
                numOfMessages = userMessages.count
                let oldestMessage = userMessages[indexPath.row]
                
                client.requestPreviousMessages(oldestMessage.date!, excludeID: oldestMessage.id as! Int, completionHandler: { (messages) in
                    self.userMessages = CoreDataOperation.fetchAllMessagesFromCoreData()!
                    if self.numOfMessages == self.userMessages.count{
                        self.reachToTheEnd = true
                    }
                    self.isLoading = false
                    self.tableView.reloadData()
                })
            }
//>>>>>>> master
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userMessageCell", forIndexPath: indexPath) as! UserMessageCell
        
        let message = userMessages[indexPath.row]

        // Configure the cell...
        cell.titleLbael.text = message.title
        cell.subtitleLabel.text = message.content
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        cell.dateLabel.text = "\(dateFormatter.stringFromDate(message.date!).uppercaseString)" + " "
        
        var messageIcon: UIImage?
        if message.viewed == true {
            messageIcon = UIImage(named: "Read")
        }
        else{
            messageIcon = UIImage(named: "Unread")
        }
        cell.imageView?.image = messageIcon
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = userMessages[indexPath.row]
        
        message.setValue(true, forKey: "viewed")
        
        CoreDataOperation.saveManagedObjectContext()
        
        self.tableView.reloadData()
        self.performSegueWithIdentifier("messageVC", sender: message)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "messageVC" {
            if let message = sender as? Message{
                let destnatinationVC = segue.destinationViewController as! MessageVC
                destnatinationVC.message = message
            
            }
        }
    }

    @IBAction func CloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateMessages(){
        client.requestAllMessages { (messages) in
            self.userMessages = CoreDataOperation.fetchAllMessagesFromCoreData()!
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        print ("updateMessages")
        
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

}
