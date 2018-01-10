//
//  Alert.swift
//  Melmel
//
//  Created by WuKaipeng on 4/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import UIKit

func alert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "确认", style: .cancel))
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        topController.present(alert, animated: true)
    }
}

class Alert {
    
    func showAlert(_ viewcontroller: UITableViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "请检查你的网络", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20),
            NSForegroundColorAttributeName : UIColor.white
            ])
        
  
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        viewcontroller.present(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = GLOBAL_TINT_COLOR
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func showTempAlert(_ viewcontroller: UIViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "此选项暂未开通", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20),
            NSForegroundColorAttributeName : hexStringToUIColor("#3299CC")
            ])
        
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        viewcontroller.present(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = hexStringToUIColor("#325C74")
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func showArchivedSuccessfullyAlert(_ viewController: UIViewController) {
        let attributedString = NSAttributedString(string: "收藏成功", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20),
            NSForegroundColorAttributeName : hexStringToUIColor("#3299CC")
            ])
        
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        viewController.present(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = hexStringToUIColor("#325C74")
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func showLoadingAlertController(_ viewController:UIViewController) {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        let loadingAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        activityIndicatorView.center = loadingAlertController.view.center
        
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
}
