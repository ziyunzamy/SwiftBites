//
//  SavedVideo+CoreDataProperties.swift
//  
//
//  Created by Ziyun Zheng on 11/27/16.
//
//

import Foundation
import CoreData


extension SavedVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedVideo> {
        return NSFetchRequest<SavedVideo>(entityName: "SavedVideo");
    }

    @NSManaged public var videoId: String?
    @NSManaged public var name: String?
    @NSManaged public var thumbnail: String?

}
