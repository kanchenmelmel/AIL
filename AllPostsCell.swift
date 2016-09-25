//
//  AllPostsCell.swift
//  AIL
//
//  Created by WuKaipeng on 25/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class AllPostsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: RoundedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
