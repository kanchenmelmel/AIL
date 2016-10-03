//
//  MenuVC.swift
//  AIL
//
//  Created by WuKaipeng on 3/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LeftMenuOption {
    case main
    case archive
    case message
    case aboutAIL
    case nonMenu
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenuOption)
}

class LeftMenuVC: UIViewController {
    
    //var mainViewController: UIViewController!
    
    // Set up view Controllers that left menu can access
    var mainVC:UIViewController!
    var archiveVC:UIViewController!
    var messageVC:UIViewController!
    var aboutAILVC:UIViewController!
    
    
    
    
//    override func awakeFromNib() {
////        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("main") {
////            self.mainViewController = controller
////        }
////        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("left") {
////            self.mainViewController = controller
////        }
//        
//        super.awakeFromNib()
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setUpAccessableVCs()
    }
    

    @IBAction func homeButtonClick(sender: AnyObject) {
        self.changeViewController(.main)
    }
    @IBAction func archiveButtonClick(sender: AnyObject) {
        self.changeViewController(.archive)
        
        
    }
    
    @IBAction func showMessageButtonClick(sender: AnyObject) {
        self.changeViewController(.message)
    }

    
    @IBAction func ShowAboutAILButtonClick(sender: AnyObject) {
        self.changeViewController(.aboutAIL)
    }
    
    
    

    @IBAction func userMessagePressed(sender: AnyObject) {
        
    }
    
    
    
    func setUpAccessableVCs() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("mainNavCtrl")
        
        
        
        let messageStoryboard = UIStoryboard(name: "Archive", bundle: nil)
        self.archiveVC = messageStoryboard.instantiateViewControllerWithIdentifier("ArchiveNavCtrl")
        
        let archiveStoryboard = UIStoryboard(name: "Messages", bundle: nil)
        self.messageVC = archiveStoryboard.instantiateViewControllerWithIdentifier("MessagesTableNavCtrl")
        
        
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

extension LeftMenuVC:LeftMenuProtocol {
    func changeViewController(menu: LeftMenuOption) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainVC, close: true)
        case .archive:
            self.slideMenuController()?.changeMainViewController(self.archiveVC, close: true)
        case .message:
            self.slideMenuController()?.changeMainViewController(self.messageVC, close: true)
        case .aboutAIL:
            self.slideMenuController()?.changeMainViewController(self.aboutAILVC, close: true)
        default:break;
        }
    }
}
