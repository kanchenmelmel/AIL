//
//  CustomizedSearchBar.swift
//  AIL
//
//  Created by Work on 21/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class CustomizedSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let searchField = subviews[0].subviews[indexOfSearchFieldInSubviews()] as! UITextField
        
        searchField.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index:Int?
        let searchBarView = self.subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count {
            print(i)
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                print(i)
                break
            }
        }
//        print(index)
        return index
    }

}
