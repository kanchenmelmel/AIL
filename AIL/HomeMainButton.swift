//
//  HomeMainButton.swift
//  AIL
//
//  Created by Wenyu Zhao on 14/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

@IBDesignable
class HomeMainButton: UIButton {
    
    let image = UIImageView(frame: CGRect(x: 10, y: 15, width: 50, height: 35))
    let label = UILabel(frame: CGRect(x: 10, y: 63, width: 50, height: 12))
    
    private var alignType = "left"
    @IBInspectable var align: String {
        get {
            return self.alignType
        }
        set(str) {
            self.alignType = str
            self.layout()
        }
    }

    @IBInspectable var text: String {
        get {
            return self.label.text!
        }
        set(str) {
            self.label.text = str
        }
    }
    
    @IBInspectable var icon: UIImage {
        get {
            return self.image.image!
        }
        set(image) {
            self.image.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.initialize()
    }
    
    override func prepareForInterfaceBuilder() {
        self.initialize()
    }
    
    

    func initialize() {
        self.backgroundColor = UIColor.whiteColor()
        if alignType == "center" {
            self.layer.cornerRadius = 70.5
            self.layer.borderWidth = 10
            self.layer.borderColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1).CGColor
            label.textColor = UIColor(red: 70 / 255, green: 118 / 255, blue: 180 / 255, alpha: 1)
        } else {
            self.layer.cornerRadius = 5
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clearColor().CGColor
            label.textColor = UIColor.blackColor()
        }
        self.clipsToBounds = true
        image.contentMode = .ScaleAspectFit
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        
        self.addSubview(image)
        self.addSubview(label)
        
        self.layout()
    }
    
    func layout() {
        if alignType == "center" {
            image.frame = CGRect(x: 0, y: 36.5, width: 141, height: 50)
            label.frame = CGRect(x: 0, y: 93, width: 141, height: 12)
        } else if alignType == "left" {
            let x = (self.frame.width - 65 - 50) / 2
            image.frame = CGRect(x: x, y: 15, width: 50, height: 35)
            label.frame =  CGRect(x: x, y: 63, width: 50, height: 12)
        } else {
            let x = (self.frame.width - 65 - 50) / 2 + 65
            image.frame = CGRect(x: x, y: 15, width: 50, height: 35)
            label.frame =  CGRect(x: x, y: 63, width: 50, height: 12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initialize()
    }
}
