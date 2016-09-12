//
//  ViewController.swift
//  AIL
//
//  Created by Work on 1/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
// test

import UIKit
import SlideMenuControllerSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainButtonsView: UIView!
    @IBOutlet weak var footerButtonsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //self.view.backgroundColor = UIColor(red: 242, green: 242, blue: 242, alpha: 1)
        
        let nvc = self.parentViewController as! UINavigationController
        nvc.setNavigationBarHidden(true, animated: false)
        
        let wordpressClient = WordPressClient()
        
        wordpressClient.requestLatestTwentyPosts { (posts) in
            print(posts.count)
        }
        
    }
    
    struct ButtonContent {
        let image: String
        let text: String
    }
    
    static let MainButtonsContent = [
        "top-left":     ButtonContent(image: "jijing.png", text: "机经题库"),
        "top-right":    ButtonContent(image: "beikao.png", text: "备考攻略"),
        "bottom-left":  ButtonContent(image: "zice.png",   text: "题型自测"),
        "bottom-right": ButtonContent(image: "mokao.png",  text: "全真模考"),
    ]
    func renderMainCornerButton(type: String, button: UIView, buttonWidth: CGFloat) {
        button.backgroundColor = UIColor.whiteColor()
        button.layer.cornerRadius = 5
        let x = type == "top-left" || type == "bottom-left" ? 33 : buttonWidth - 83
        let image = UIImageView(frame: CGRect(x: x, y: 15, width: 50, height: 35))
        image.contentMode = .ScaleAspectFit
        image.image = UIImage(named: ViewController.MainButtonsContent[type]!.image)
        button.addSubview(image)
        let label = UILabel(frame: CGRect(x: x, y: 63, width: 50, height: 12))
        label.text = ViewController.MainButtonsContent[type]!.text
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        button.addSubview(label)
    }
    
    func renderMainButtons() {
        mainButtonsView.backgroundColor = UIColor.clearColor()
        let rect = mainButtonsView.bounds.size
        let (w, h) = ((rect.width - 10) / 2, (rect.height - 10) / 2);
        // render 4 corner buttons
        let buttons = [
            "top-left":     UIView(frame: CGRect(x: 0,      y: 0,      width: w,   height: h)),
            "top-right":    UIView(frame: CGRect(x: w + 10, y: 0,      width: w,   height: h)),
            "bottom-left":  UIView(frame: CGRect(x: 0,      y: h + 10, width: w,   height: h)),
            "bottom-right": UIView(frame: CGRect(x: w + 10, y: h + 10, width: w,   height: h)),
        ]
        for type in buttons.keys {
            self.renderMainCornerButton(type, button: buttons[type]!, buttonWidth: w)
            mainButtonsView.addSubview(buttons[type]!)
        }
        // render center circle buttons
        let circleButton = UIView(frame: CGRect(
            x: (rect.width - 141) / 2,
            y: (rect.height - 141) / 2,
            width: 141,
            height: 141
        ))
        circleButton.layer.borderColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1).CGColor
        circleButton.layer.borderWidth = 10
        circleButton.backgroundColor = UIColor.whiteColor()
        circleButton.layer.cornerRadius = 141 / 2
        circleButton.clipsToBounds = true
        let image = UIImageView(image: UIImage(named: "pte.png"))
        image.contentMode = .ScaleAspectFit
        image.frame = CGRect(x: 0, y: 36.5, width: 141, height: 50)
        circleButton.addSubview(image)
        let label = UILabel(frame: CGRect(x: 0, y: 93, width: 141, height: 12))
        label.text = "PTE素材资料"
        label.textColor = UIColor(red: 70 / 255, green: 118 / 255, blue: 180 / 255, alpha: 1)
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        circleButton.addSubview(label)
        mainButtonsView.addSubview(circleButton)
    }
    
    static let FooterButtonsContent = [
        ButtonContent(image: "baokao.png", text: "报考流程"),
        ButtonContent(image: "lianxi.png", text: "联系我们"),
        ButtonContent(image: "peixun.png",   text: "培训课程"),
    ]
    
    func renderFooterButton(index: Int, button: UIView, buttonWidth: CGFloat) {
        button.backgroundColor = UIColor.whiteColor()
        let x = (buttonWidth - 50) / 2
        let image = UIImageView(frame: CGRect(x: x, y: 15, width: 50, height: 35))
        image.contentMode = .ScaleAspectFit
        image.image = UIImage(named: ViewController.FooterButtonsContent[index].image)
        button.addSubview(image)
        let label = UILabel(frame: CGRect(x: x, y: 63, width: 50, height: 12))
        label.text = ViewController.FooterButtonsContent[index].text
        label.textColor = index != 1 ? UIColor.blackColor() : UIColor(red: 70 / 255, green: 118 / 255, blue: 180 / 255, alpha: 1)
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        button.addSubview(label)
    }
    
    func renderFooterButtons() {
        footerButtonsView.backgroundColor = UIColor.clearColor()
        let rect = footerButtonsView.bounds.size
        let (w, h) = ((rect.width - 2) / 3, rect.height)
        let buttons = [
            UIView(frame: CGRect(x: 0,         y: 0, width: w, height: h)),
            UIView(frame: CGRect(x: w + 1,     y: 0, width: w, height: h)),
            UIView(frame: CGRect(x: 2 * w + 2, y: 0, width: w, height: h)),
        ]
        for index in 0..<3 {
            self.renderFooterButton(index, button: buttons[index], buttonWidth: w)
            footerButtonsView.addSubview(buttons[index])
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.setNavigationBarItem()
        self.renderMainButtons()
        self.renderFooterButtons()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as? PostCollectionViewCell {
            return cell
        }
            
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO Goes to another view controller
    }
    
/*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.size.width/3.2, height: 100)
        return CGSize(width: 288.5, height: 155.5)
    }*/
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
}

