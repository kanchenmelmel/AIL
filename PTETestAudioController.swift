//
//  SelfTestDBViewController.swift
//  AIL
//
//  Created by Work on 12/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class PTETestAudioController: UIViewController {

    //@IBOutlet weak var randomTestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        // Do any additional setup after loading the view.
        //randomTestButton.layer.cornerRadius = 5.0
    }

    enum Category {
        case readAloud
        case repeatSentence
        case describeImage
        case writeFromDictation
        case random
    }
    @IBAction func handleReadAloudButtonPress(_ sender: Any) {
        presentWebView(.readAloud)
    }
    @IBAction func handleRepeatSentenceButtonPress(_ sender: Any) {
        presentWebView(.repeatSentence)
    }
    @IBAction func handleDescribeImageButtonPress(_ sender: Any) {
        presentWebView(.describeImage)
    }
    @IBAction func handleWriteFromDictationButtonPress(_ sender: Any) {
        presentWebView(.writeFromDictation)
    }
    @IBAction func handleRandomButtonPress(_ sender: Any) {
        presentWebView(.random)
    }
    func presentWebView(_ category: Category) {
        let audioWebView = self.storyboard?.instantiateViewController(withIdentifier: "PTEAudioWebViewController") as? PTETestAudioWebViewController
        audioWebView?.category = category;
        self.navigationController?.pushViewController(audioWebView!, animated: true)
    }
}
