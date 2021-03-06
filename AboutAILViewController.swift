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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var showLeftPanelButton = true
    
    let textFieldPlaceholder = "请写下你的问题......"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
        
        self.messageTextView.delegate = self
        self.nameTextField.delegate = self
        self.contactTextField.delegate = self
        
        if showLeftPanelButton {
            self.setNavigationBarItem()
        }
        
        
        
    }
    
    func sendMessageButtonPressed() {
        if self.checkFieldsEmpty() {
        let name = self.nameTextField.text!
        let contact = self.contactTextField.text!
        let message = self.messageTextView.text!
        let emailAddress = emailTextField.text!
        let loadingAlert = UIAlertController(title:"发送中……",message:nil,preferredStyle: .alert)
        self.present(loadingAlert, animated: true, completion: nil)
        let email = Email(
            from: "Australian Institute of Language 用户反馈 <user-feedback.noreply@ail.vic.edu.au>",
            to: "Australian Institute of Language <pte@ail.vic.edu.au>", // TODO: Replace email address with: pte@ail.vic.edu.au
            title: "用户反馈 (Australian Institute of Language iOS客户端)",
            content: "姓名：\(name)\n电话：\(contact)\n邮箱：\(emailAddress)\n反馈信息：\n\n\(message)"
        )
        clearTextFields()
        (EmailEjector.eject(email: email)) { _ in
            let alert = UIAlertController(
                title: "发送成功",
                message: "您的反馈已收到",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default) { _ in
                //print("done")
                })
            loadingAlert.dismiss(animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //print("test")
        if text == "\n" {
            self.messageTextView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textFieldPlaceholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textFieldPlaceholder
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            showStandardAlert("请问您想拨打电话么？", message: "96708868", okAction: {
                let phoneNumber = "tel://96708868"
                UIApplication.shared.openURL(URL(string:phoneNumber)!)
                }, cancleAction: nil)
            
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            
            showStandardAlert("请问你想发送邮件么？", message: "pte@ail.vic.edu.au", okAction: { 
                let email = "mailto://pte@ail.vic.edu.au"
                UIApplication.shared.openURL(URL(string:email)!)
                }, cancleAction: nil)
            
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            let url = URL(string:
                "comgooglemaps://?q=墨尔本无忧雅思培训学校&center=-37.8142814,144.96208969999998".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)

            
//             UIApplication.sharedApplication().openURL(url!)
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                showStandardAlert("请问你想打开Google Maps", message: "AIL", okAction: {
                    UIApplication.shared.openURL(url!)
                    }, cancleAction: nil)
                
            } else {
                showStandardAlert("你没有安装Google Maps", message: nil, okAction: nil, cancleAction: nil)
            }

        }
    }
    
    func clearTextFields() {
        self.nameTextField.text = ""
        self.contactTextField.text = ""
        self.emailTextField.text = ""
        self.messageTextView.text = textFieldPlaceholder
    }
    
    func checkFieldsEmpty() -> Bool {
        if self.nameTextField.text == "" || contactTextField.text == "" || emailTextField.text == "" || messageTextView.text == textFieldPlaceholder {
            let alert = UIAlertController(title: "请输入相应表单信息。", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
