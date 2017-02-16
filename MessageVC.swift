//
//  MessageVC.swift
//  AIL
//
//  Created by WuKaipeng on 4/10/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var message:Message?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = message?.title
        subtitleLabel.text = message?.content
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "\(dateFormatter.string(from: (message?.date)! as Date).uppercased())" + " "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
