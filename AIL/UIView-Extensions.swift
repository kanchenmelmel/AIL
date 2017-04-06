//
//  CALayer+xBorderColor.swift
//  AIL
//
//  Created by Wenyu Zhao on 18/3/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    @IBInspectable var _borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var _borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var _cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    @IBInspectable var _circle: Bool {
        get {
            return abs(layer.cornerRadius - layer.frame.height) <= CGFloat(FLT_EPSILON)
        }
        set {
            if (newValue) {
                layer.cornerRadius = layer.frame.height / 2.0;
                layer.masksToBounds = true
            }
        }
    }
}
