//
//  Message+CoreDataProperties.swift
//  AIL
//
//  Created by WuKaipeng on 28/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import CoreData


extension Message {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
//        return NSFetchRequest<Message>(entityName: "Message");
//    }

    @NSManaged public var date: NSDate?
    @NSManaged public var featureImageDownloaded: NSNumber?
    @NSManaged public var featureImageUrl: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var viewed: NSNumber?

}
