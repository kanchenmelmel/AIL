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
        self.init(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.isHidden = true
        self.backgroundColor = UIColor.white
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.bounds.width / 2.0 - 25,y: self.bounds.height / 2.0 - 25, width: 50,height: 50), type: .ballPulse, color: UIColor.tintColor(), padding: 0)
        self.addSubview(activityIndicator!)
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicator?.startAnimating()
    }
    
    func stopAnimating() {
        self.isHidden = true
        self.activityIndicator?.stopAnimating()
    }

}
