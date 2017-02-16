//
//  CustomizedSegmentedControl.swift
//  AIL
//
//  Created by Work on 27/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedSegmentedControl: UIControl {
    
    
    fileprivate var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["PTE周末班", "PTE冲刺班", "VIP 一对一","刷题讲解班"] {
        didSet {
            setupLabels()
        }
    }
    
    
    
    var selectedIndex : Int = 0 {
        didSet {            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var segmentedControlBorderColor : UIColor = UIColor.white {
        didSet {
            setSegmentedControlBorderColor()
        }
    }
    
    @IBInspectable var segmentedControlBorderWidth : CGFloat = 1.0 {
        didSet{
            setSegmentedControlBorderWidth()
        }
    }
    
    @IBInspectable var thumbViewHeight:CGFloat = 1.0 {
        didSet{
            setThumbViewheight()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        
        //layer.cornerRadius = frame.height / 2
        layer.borderColor = segmentedControlBorderColor.cgColor
        layer.borderWidth = segmentedControlBorderWidth
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont(name: "Avenir-Black", size: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            //label.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = CGRect(x: selectFrame.origin.x,y: selectFrame.size.height-10.0,width: selectFrame.size.width,height: 10.0)
        thumbView.backgroundColor = thumbColor
        //thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
            
            let selectFrame = label.frame
            self.thumbView.frame = CGRect(x: selectFrame.origin.x,y: selectFrame.size.height - self.thumbViewHeight,width: selectFrame.size.width, height: self.thumbViewHeight)
            

            
            }, completion: nil)
        
        
        
    }
    
    func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
        
        //let constraints = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: nextButton, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
    
    func setSegmentedControlBorderColor() {
        layer.borderColor = segmentedControlBorderColor.cgColor
    }
    
    func setSegmentedControlBorderWidth() {
        layer.borderWidth = segmentedControlBorderWidth
    }
    
    func setThumbViewheight() {
        thumbView.frame = CGRect(x: thumbView.frame.origin.x,y: thumbView.frame.size.height - thumbViewHeight,width: thumbView.frame.size.width, height: thumbViewHeight)
        
    }

}
