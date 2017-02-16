//
//  SelfTestDBHomeButton.swift
//  AIL
//
//  Created by Work on 13/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

@IBDesignable
class SelfTestDBHomeButton: UIButton {

    let buttonImgView = UIImageView()
    let buttonLabel = UILabel()
    //    let stackView = UIStackView()
    
    
    @IBInspectable
    var labelText:String? {
        get {
            return self.buttonLabel.text
        }
        set(textString) {
            self.buttonLabel.text = textString
        }
    }
    @IBInspectable
    var buttonImg: UIImage? {
        get {
            return self.buttonImgView.image
        }
        set(image) {
            self.buttonImgView.image = image
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.setUpButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setUpButton()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setUpButton()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpButton()
    }
    override func layoutSubviews() {
        self.setUpButton()
    }
    
    func setUpButton(){
        
//        self.frame.size.height = 87.5
        buttonImgView.frame.size = CGSize(width: 46, height: 50)
        buttonImgView.frame.origin = CGPoint(x: self.frame.width / 2.0 - buttonImgView.frame.width / 2.0, y: (self.frame.height-78)/2.0)
        buttonImgView.contentMode = .center
        
        buttonLabel.frame.size = CGSize(width: 80, height: 13)
        buttonLabel.frame.origin = CGPoint(x: self.frame.width / 2.0 - buttonLabel.frame.width / 2.0, y: (self.frame.height-78)/2.0 + 65)
        buttonLabel.font = UIFont.systemFont(ofSize: 13.0)
        buttonLabel.textAlignment = .center
        self.layer.cornerRadius = 5.0
        
        
        
        
        
        self.addSubview(buttonImgView)
        self.addSubview(buttonLabel)
        //        stackView.centerXAnchor.constraintEqualToAnchor((superview?.centerXAnchor)!).active = true
        //        stackView.centerYAnchor.constraintEqualToAnchor((superview?.centerYAnchor)!).active = true
    }
}
