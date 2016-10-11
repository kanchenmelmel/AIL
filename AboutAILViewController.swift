//
//  AboutAILViewController.swift
//  AIL
//
//  Created by Work on 4/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import CoreLocation

class AboutAILViewController: UITableViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), forControlEvents: .TouchUpInside)
        
        
        // Do any additional setup after loading the view.
        
        self.messageTextView.delegate = self
        self.nameTextField.delegate = self
        self.contactTextField.delegate = self
        self.setNavigationBarItem()
        
        
    }
    
    func sendMessageButtonPressed() {
        let name = self.nameTextField.text!
        let contact = self.contactTextField.text!
        let message = self.messageTextView.text!
        
        let email = Email(
            from: "Australian Institute of Language 用户反馈 <user-feedback.noreply@ail.vic.edu.au>",
            to: "Australian Institute of Language <patrickgao1990@gmail.com>", // TODO: Replace email address with: pte@ail.vic.edu.au
            title: "用户反馈 (Australian Institute of Language iOS客户端)",
            content: "姓名：\(name)\n联系方式：\(contact)\n反馈信息：\n\n\(message)"
        )
        
        (EmailEjector.eject(email: email)) { _ in
            let alert = UIAlertController(
                title: "发送成功",
                message: "您的反馈已收到",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { _ in
                print("done")
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        print("test")
        if text == "\n" {
            self.messageTextView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "写下你的问题......" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "写下你的问题......"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
     Table cell Action
     */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let phoneNumber = "tel://96708868"
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            let email = "mailto://pte@ail.vic.edu.au"
            UIApplication.sharedApplication().openURL(NSURL(string:email)!)
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?q=AIL&center=-37.8142814,144.96208969999998")!)
//            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
//                UIApplication.sharedApplication().openURL(NSURL(string:
//                    "comgooglemaps://?q=AIL&center=-37.8142814,144.96208969999998")!)
//            } else {
//                print("Can't use comgooglemaps://");
//            }
            
            
            
            
//            let address = "Level 2,388 Bourke St., Melbourne, 3000"
//            let geocoder = CLGeocoder()
//             // A string of the address info you already have
//            geocoder.geocodeAddressString(address) { (placemarksOptional, error) -> Void in
//                if let placemarks = placemarksOptional {
//                    print("placemark| \(placemarks.first)")
//                    if let location = placemarks.first?.location {
//                        let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
//                        let path = "http://maps.apple.com/" + query
//                        if let url = NSURL(string: path) {
//                            UIApplication.sharedApplication().openURL(url)
//                        } else {
//                            // Could not construct url. Handle error.
//                        }
//                    } else {
//                        // Could not get a location from the geocode request. Handle error.
//                    }
//                } else {
//                    // Didn't get any placemarks. Handle error.
//                }
//            }
        }
    }
}
