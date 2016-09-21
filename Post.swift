//
//  Post.swift
//  AIL
//
//  Created by Work on 6/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import CoreData


enum PhotoRecordState {
    case New, Downloaded, Failed
}

class Post: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var featuredImage : UIImage?
    var featuredLoadingImageState : PhotoRecordState = .New

}
