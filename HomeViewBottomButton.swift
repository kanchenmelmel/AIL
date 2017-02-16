//
//  HomeViewBottomButton.swift
//  AIL
//
//  Created by Work on 23/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit


@IBDesignable
class HomeViewBottomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
        print("ttttt")
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
        
        self.frame.size.height = 87.5
        buttonImgView.frame.size = CGSize(width: 41.0, height: 41.0)
        buttonImgView.frame.origin = CGPoint(x: self.frame.width / 2.0 - buttonImgView.frame.width / 2.0, y: 15.5)
        buttonImgView.contentMode = .center
        
        buttonLabel.frame.size = CGSize(width: 45.5, height: 11.0)
        buttonLabel.frame.origin = CGPoint(x: self.frame.width / 2.0 - buttonLabel.frame.width / 2.0, y: 63.5)
        buttonLabel.font = UIFont.systemFont(ofSize: 11.0)
        
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
