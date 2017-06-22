//
//  MenuVC.swift
//  AIL
//
//  Created by WuKaipeng on 3/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Alamofire
import OAuthSwift



enum LeftMenuOption {
    case userInfo
    case main
    case rewardAccount
    case archive
    case message
    case aboutAIL
    case nonMenu
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenuOption)
}


class LeftMenuVC: UIViewController {
    
    //var mainViewController: UIViewController!
    
    // Set up view Controllers that left menu can access
    var mainVC:UIViewController!
    var rewardAccountVC:UIViewController!
    var archiveVC:UIViewController!
    var messageVC:UIViewController!
    var aboutAILVC:UIViewController!
    var userInfoVC:UIViewController!
    
    
    @IBOutlet weak var credButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setUpAccessableVCs()
        //self.updateCredit()
    }
    

    @IBAction func homeButtonClick(_ sender: AnyObject) {
        self.changeViewController(.main)
    }
    @IBAction func rewardAccountButtonClick(_ sender: AnyObject) {
        self.changeViewController(.rewardAccount)
    }
    
    @IBAction func archiveButtonClick(_ sender: AnyObject) {
        self.changeViewController(.archive)
        
        
    }
    
    @IBAction func showMessageButtonClick(_ sender: AnyObject) {
        self.changeViewController(.message)
    }

    
    @IBAction func ShowAboutAILButtonClick(_ sender: AnyObject) {
        self.changeViewController(.aboutAIL)
    }
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    var credLoggedIn = false
    var credit = ""
    var userLogin = ""
    func updateCredit() {
        let obj = UserDefaults.standard.object(forKey: "myCredUserIdentifier")
        if obj != nil && (obj! as! String) != "" {
            let value = obj! as! String
            let field = isValidEmail(value) ? "email" : "login"
            Alamofire.request("http://ail.vic.edu.au/cred.php?field=\(field)&value=\(value)").responseJSON { response in
                if let json = response.result.value as? [String: AnyObject] {
                    if json["ok"] as! Bool {
                        self.credLoggedIn = true
                        self.credit = "\(json["credit"]!)"
                        self.userLogin = "\(json["user_login"]!)"
                        self.credButton.setTitle("\(self.userLogin) 积分：\(self.credit)", for: .normal)
                        return
                    }
                }
                self.credLoggedIn = false
                UserDefaults.standard.removeObject(forKey: "myCredUserIdentifier")
                let alert = UIAlertController(title: "获取积分失败", message: "用户名／邮箱错误", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确认", style: .cancel))
                self.present(alert, animated:true)
                self.credButton.setTitle("登录查看积分", for: .normal)
            }
        } else {
            self.credLoggedIn = false
            self.credButton.setTitle("登录查看积分", for: .normal)
        }
    }
    @IBAction func userInfoButtonClick(_ sender: AnyObject) {
        /*WPClient.authorize() { done in
            print(done ? "Auth Succeeded" : "Auth Failed")
            WPClient.users() { data in
                print(data)
            }
        }*/
        
        if self.credLoggedIn {
            let alert = UIAlertController(title: self.userLogin, message: "积分: \(self.credit)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "退出登录", style: .destructive) { _ in
                UserDefaults.standard.removeObject(forKey: "myCredUserIdentifier")
                self.updateCredit()
            })
            
            alert.addAction(UIAlertAction(title: "确认", style: .cancel))
            
            self.present(alert, animated:true)
        } else {
            let alert = UIAlertController(title: "AIL登录", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确认", style: .default) { _ in
                if let user = alert.textFields![0].text {
                    UserDefaults.standard.set(user, forKey: "myCredUserIdentifier")
                    UserDefaults.standard.synchronize()
                    self.updateCredit()
                }
            })
            alert.addTextField() { textField in
                textField.placeholder = "用户名"
            }
            self.present(alert, animated:true, completion:nil)
        }
        
        
    }
    

    @IBAction func userMessagePressed(_ sender: AnyObject) {
        
    }
    
    
    
    func setUpAccessableVCs() {
        let userInfoStoryboard = UIStoryboard(name: "UserInfo", bundle: nil)
        self.userInfoVC = userInfoStoryboard.instantiateViewController(withIdentifier: "UserInfoNavCtrl")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mainVC = mainStoryboard.instantiateViewController(withIdentifier: "mainNavCtrl")
        
        
        let rewardAccountStoryboard = UIStoryboard(name: "RewardAccount", bundle: nil)
        self.rewardAccountVC = rewardAccountStoryboard.instantiateViewController(withIdentifier: "RewardAccountNavCtrl")
        
        
        let messageStoryboard = UIStoryboard(name: "Archive", bundle: nil)
        self.archiveVC = messageStoryboard.instantiateViewController(withIdentifier: "ArchiveNavCtrl")
        
        let archiveStoryboard = UIStoryboard(name: "Messages", bundle: nil)
        self.messageVC = archiveStoryboard.instantiateViewController(withIdentifier: "MessagesTableNavCtrl")
        
        let aboutAILStoryboard = UIStoryboard(name: "AboutAIL", bundle: nil)
        self.aboutAILVC = aboutAILStoryboard.instantiateViewController(withIdentifier: "AboutAILNavCtrl")
        
        
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
    func changeViewController(_ menu: LeftMenuOption) {
        switch menu {
        case .userInfo:
            self.slideMenuController()?.changeMainViewController(self.userInfoVC, close: true)
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainVC, close: true)
        case .rewardAccount:
            self.slideMenuController()?.changeMainViewController(self.rewardAccountVC, close: true)
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
