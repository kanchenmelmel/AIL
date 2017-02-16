//
//  UIImageViewDesignableExtension.swift
//  AIL
//
//  Created by Work on 14/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView:UIImageView { }


extension UIImageView {
    /*
    @IBInspectable
    var cornerRadius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    */
}

@IBDesignable class RoundedButton:UIButton { }

extension UIView {
    
    @IBInspectable
    var cornerRadius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    
    
    
    
}
