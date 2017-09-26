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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAccessableVCs()
        self.initializeUser()
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
    
    var credit = ""
    
    func initializeUser() {
        if let auth = UserDefaults.standard.string(forKey: "WordPress-Basic-Auth") {
            print("Start Auth")
            WPClient.authorize(auth: auth) { x in
                print("Auth: \(x)")
                self.updateUserInfo()
            }
        } else {
            self.updateUserInfo()
        }
    }
    
    func updateUserInfo() {
        WPClient.credit() { _credit in
            if let credit = _credit {
                self.credit = "\(credit)";
                let userName = WPClient.me!["name"] as! String
                self.usernameLabel.text = userName
                self.creditLabel.text = "积分: \(self.credit)"
            } else {
                self.usernameLabel.text = "未登录"
                self.creditLabel.text = " "
            }
        }
    }
    
    @IBAction func userInfoButtonClick(_ sender: AnyObject) {
        if WPClient.authorized {
            let userName = WPClient.me?["name"] as! String
            let alert = UIAlertController(title: userName, message: "积分: \(self.credit)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "退出登录", style: .destructive) { _ in
                UserDefaults.standard.removeObject(forKey: "WordPress-Basic-Auth")
                WPClient.clear()
                self.initializeUser()
            })
            alert.addAction(UIAlertAction(title: "确认", style: .cancel))
            self.present(alert, animated:true)
        } else {
            let alert = UIAlertController(title: "AIL登录", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "登录", style: .default) { _ in
                if let user = alert.textFields![0].text, let pass = alert.textFields![1].text {
                    let auth = Data("\(user):\(pass)".utf8).base64EncodedString()
                    UserDefaults.standard.set(auth, forKey: "WordPress-Basic-Auth")
                    UserDefaults.standard.synchronize()
                    self.initializeUser()
                }
            })
            alert.addTextField() { textField in
                textField.placeholder = "用户名"
            }
            alert.addTextField() { textField in
                textField.placeholder = "密码"
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
