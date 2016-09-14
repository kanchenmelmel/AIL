//
//  MainButtonsContainer.swift
//  AIL
//
//  Created by Wenyu Zhao on 14/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit


class MainButtonsContainer: UIView {

    var centreButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    var cornerButtons = [
        "top-left":     UIButton(frame: CGRect(x: 0, y: 0, width: 10,   height: 10)),
        "top-right":    UIButton(frame: CGRect(x: 0, y: 0, width: 10,   height: 10)),
        "bottom-left":  UIButton(frame: CGRect(x: 0, y: 0, width: 10,   height: 10)),
        "bottom-right": UIButton(frame: CGRect(x: 0, y: 0, width: 10,   height: 10)),
    ]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        backgroundColor = UIColor.redColor()
        for button in cornerButtons.values {
            button.backgroundColor = UIColor.redColor()
            addSubview(button)
        }
        addSubview(centreButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clearColor()
        let (w, h) = ((frame.width - 10) / 2, (frame.height - 10) / 2);
        cornerButtons["top-left"]!.frame = CGRect(x: 0, y: 0, width: w, height: h)
        cornerButtons["top-right"]!.frame = CGRect(x: w + 10, y: 0, width: w, height: h)
        cornerButtons["bottom-left"]!.frame = CGRect(x: 0, y: h + 10, width: w, height: h)
        cornerButtons["bottom-right"]!.frame = CGRect(x: w + 10, y: h + 10, width: w, height: h)
        
        for type in cornerButtons.keys {
            self.renderMainCornerButton(type, button: cornerButtons[type]!, buttonWidth: w)
        }
        
        // render center circle buttons
        centreButton.frame =  CGRect(x: (frame.width - 141) / 2, y: (frame.height - 141) / 2, width: 141, height: 141)
        centreButton.layer.borderColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1).CGColor
        centreButton.layer.borderWidth = 10
        centreButton.backgroundColor = UIColor.whiteColor()
        centreButton.layer.cornerRadius = 141 / 2
        centreButton.clipsToBounds = true
        let image = UIImageView(image: UIImage(named: "pte.png"))
        image.contentMode = .ScaleAspectFit
        image.frame = CGRect(x: 0, y: 36.5, width: 141, height: 50)
        centreButton.addSubview(image)
        let label = UILabel(frame: CGRect(x: 0, y: 93, width: 141, height: 12))
        label.text = "PTE素材资料"
        label.textColor = UIColor(red: 70 / 255, green: 118 / 255, blue: 180 / 255, alpha: 1)
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        centreButton.addSubview(label)
    }
    
    struct ButtonContent {
        let image: String
        let text: String
    }
    
    let MainButtonsContent = [
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
        image.image = UIImage(named: MainButtonsContent[type]!.image)
        button.addSubview(image)
        let label = UILabel(frame: CGRect(x: x, y: 63, width: 50, height: 12))
        label.text = MainButtonsContent[type]!.text
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        button.addSubview(label)
    }
}
