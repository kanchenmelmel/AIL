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
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        postImage.layer.cornerRadius = 10
        postImage.clipsToBounds = true
    }
}
