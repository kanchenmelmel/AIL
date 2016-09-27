//
//  CustomizedSegmentedControl.swift
//  AIL
//
//  Created by Work on 27/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedSegmentedControl: UISegmentedControl {
    
    
    private var labels = [UILabel]()
    
    var items:[String] = ["Item 1","Item 2","Item 3"] {
        set {
            setupLabels()
        }
    }
    
    var selectedIndex : int = 0 {
        set {
            displayNewSelectedIndex()
        }
    }
    
    func setupLabels(){
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepCapacity: true)
        
        for index in 0...items.count-1 {
            let label = UILabel(frame: CGRectZero)
            label.text = items[index]
            label.textAlignment = .Center
            label.textColor = UIColor(red: 69.0/255.0, green: 119.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            self.addSubview(label)
            
            labels.append(label)
        }
    }
//    @IBInspectable
//    var selectedBackgroundImage:UIImage? {
//        get {
//            return backgroundImageForState(.Selected, barMetrics: .Default)
//        }
//        
//        set(image) {
//            self.setBackgroundImage(image, forState: .Selected, barMetrics: .Default)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSegmentedControl()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        setUpSegmentedControl()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setUpSegmentedControl() {
        //Set slected background Img
        self.setBackgroundImage(UIImage(contentsOfFile: "Read"), forState: .Selected, barMetrics: UIBarMetrics.Default)
        
    }

}
