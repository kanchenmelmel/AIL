//
//  PostCollectionViewCell.swift
//  AIL
//
//  Created by WuKaipeng on 3/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
<<<<<<< HEAD
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false;
        
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 2;
        
        //self.clipsToBounds = true
        
        NSLog("xxx")
=======
        layer.cornerRadius = 10
        clipsToBounds = true
        //layer.borderWidth = 1
        layer.borderColor = UIColor.clearColor().CGColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.masksToBounds = false
        
>>>>>>> master
        
        postImage.layer.cornerRadius = 10
        postImage.clipsToBounds = true
       // postLabel.textColor = UIColor.blueColor()
    }
}
