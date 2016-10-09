//
//  CustomizeActivityIndicatorView.swift
//  AIL
//
//  Created by Work on 9/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CustomizeActivityIndicatorView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var activityIndicator:NVActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.hidden = true
        self.backgroundColor = UIColor.whiteColor()
        activityIndicator = NVActivityIndicatorView(frame: CGRectMake(self.bounds.width / 2.0 - 25,self.bounds.height / 2.0 - 25, 50,50), type: .BallPulse, color: UIColor.tintColor(), padding: 0)
        self.addSubview(activityIndicator!)
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicator?.startAnimating()
    }
    
    func stopAnimating() {
        self.hidden = true
        self.activityIndicator?.stopAnimating()
    }

}
