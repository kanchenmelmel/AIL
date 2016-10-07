//
//  Alert.swift
//  Melmel
//
//  Created by WuKaipeng on 4/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import UIKit


class Alert {
    
    func showAlert(viewcontroller: UITableViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "请检查你的网络", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ])
        
  
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
        viewcontroller.presentViewController(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = GLOBAL_TINT_COLOR
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func showTempAlert(viewcontroller: UIViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "此选项暂未开通", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName : hexStringToUIColor("#3299CC")
            ])
        
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
        viewcontroller.presentViewController(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = hexStringToUIColor("#325C74")
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func showArchivedSuccessfullyAlert(viewController: UIViewController) {
        let attributedString = NSAttributedString(string: "收藏成功", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName : hexStringToUIColor("#3299CC")
            ])
        
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
        viewController.presentViewController(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = hexStringToUIColor("#325C74")
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func showLoadingAlertController(viewController:UIViewController) {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let loadingAlertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        activityIndicatorView.center = loadingAlertController.view.center
        
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
