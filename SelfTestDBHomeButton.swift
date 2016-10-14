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
        buttonImgView.frame.size = CGSizeMake(46, 50)
        buttonImgView.frame.origin = CGPointMake(self.frame.width / 2.0 - buttonImgView.frame.width / 2.0, (self.frame.height-39)/2.0)
        buttonImgView.contentMode = .Center
        
        buttonLabel.frame.size = CGSizeMake(80, 13)
        buttonLabel.frame.origin = CGPointMake(self.frame.width / 2.0 - buttonLabel.frame.width / 2.0, (self.frame.height-39)/2.0 + 65)
        buttonLabel.font = UIFont.systemFontOfSize(13.0)
        
        //        stackView.addArrangedSubview(buttonImgView)
        //        stackView.addArrangedSubview(buttonLabel)
        //
        //        stackView.alignment = .Center
        //        stackView.distribution = .EqualSpacing
        //        stackView.axis = .Vertical
        
        
        
        self.addSubview(buttonImgView)
        self.addSubview(buttonLabel)
        //        stackView.centerXAnchor.constraintEqualToAnchor((superview?.centerXAnchor)!).active = true
        //        stackView.centerYAnchor.constraintEqualToAnchor((superview?.centerYAnchor)!).active = true
    }
}
