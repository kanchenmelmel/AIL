//
//  MenuVC.swift
//  AIL
//
//  Created by WuKaipeng on 3/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuVC: UIViewController {
    
    //var mainViewController: UIViewController!
    
    override func awakeFromNib() {
//        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("main") {
//            self.mainViewController = controller
//        }
//        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("left") {
//            self.mainViewController = controller
//        }
        super.awakeFromNib()
    }

    @IBAction func archiveButtonClick(sender: AnyObject) {
        
        
    }
    
    @IBAction func showMessageTableVC(sender: AnyObject) {
        let slideMenuController = self.slideMenuController()
        
        slideMenuController!.performSegueWithIdentifier("showMessagesTableViewSegue", sender: slideMenuController)
    }
    
    @IBAction func ShowAboutAILButtonClick(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func userMessagePressed(sender: AnyObject) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
