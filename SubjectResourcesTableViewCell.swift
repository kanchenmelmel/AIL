//
//  SubjectResourcesTableViewCell.swift
//  AIL
//
//  Created by Work on 13/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit

class SubjectResourcesTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: RoundedImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
