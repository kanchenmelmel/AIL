//
//  Post+CoreDataClass.swift
//  AIL
//
//  Created by Work on 22/9/16.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import UIKit
import CoreData

enum PhotoRecordState {
    case new, downloaded, failed
}
open class Post: NSManagedObject {
    var featuredImage : UIImage?
    var featuredLoadingImageState : PhotoRecordState = .new
}
