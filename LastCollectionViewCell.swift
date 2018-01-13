//
//  LastCollectionViewCell.swift
//  AIL
//
//  Created by Work on 5/10/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class LastCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
        clipsToBounds = true
        //layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = true
        //self.backgroundColor = UIColor.whiteColor()
        
        
//        postImage.layer.cornerRadius = 10
//        postImage.clipsToBounds = true
    }
    
}
