//
//  FrequencyWaveView.swift
//  AIL
//
//  Created by Wenyu Zhao on 27/5/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import Foundation
import UIKit
/*
func sigmoid(_ x: Float) -> Float {
    return 1 / (1 + exp(-x))
}
*/
class FrequencyWaveView : UIView {
    var data: [Float] = []
    var maxValue = CGFloat(1000)
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect);
        
        context.setStrokeColor(UIColor.tintColor().cgColor);
        context.setLineWidth(1.0);
        if data.count > 1 {
            for i in 1..<data.count {
                let h1 = rect.height * CGFloat(data[i - 1])
                let h2 = rect.height * CGFloat(data[i])
                if data[i - 1] > 0 && data[i] > 0 {
                    context.move(to: CGPoint(x: CGFloat(i - 1), y: rect.height - h1))
                    context.addLine(to: CGPoint(x: CGFloat(i), y: rect.height - h2))
                }
            }
        }
        context.strokePath();
    }
    public func update(_ x: Float) {
        data.append(x / 1100)
        if data.count > Int(self.bounds.width) {
            data.remove(at: 0)
        }
        self.setNeedsDisplay()
    }
    public func clear() {
        data = []
        self.setNeedsDisplay()
    }
}

