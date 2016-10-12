//
//  UserMessageCell.swift
//  AIL
//
//  Created by WuKaipeng on 14/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class UserMessageCell: UITableViewCell {
    
    @IBOutlet weak var titleLbael: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
