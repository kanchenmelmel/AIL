//
//  CustomUINavigationController.swift
//  AIL
//
//  Created by WuKaipeng on 12/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit


@IBDesignable
class CustomUINavigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor.red
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        
    }
    
    override func viewDidLoad() {
        //navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor.red
    }

}
