//
//  WaveView.swift
//  AIL
//
//  Created by Wenyu Zhao on 12/5/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import Foundation
import UIKit

class WaveView : UIView {
    var data: [Float] = []
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\(rect)")
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect);
        //context.clear(rect)
        
        context.setStrokeColor(UIColor.tintColor().cgColor);
        context.setLineWidth(1.0);
        for i in 0..<data.count {
            let y = rect.height / CGFloat(2.0) * CGFloat(data[i]) / CGFloat(100.0)
            context.move(to: CGPoint(x: CGFloat(i), y: rect.height / CGFloat(2) - y))
            context.addLine(to: CGPoint(x: CGFloat(i), y: rect.height / CGFloat(2) + y))
        }
        context.strokePath();
    }
    public func update(_ x: Float) {
        data.append(x)
        if data.count > Int(self.bounds.width) {
            data.remove(at: 0)
        }
        self.setNeedsDisplay()
        //self.draw(self.frame)
    }
}
