//
//  SavedRecipe+CoreDataProperties.swift
//  
//
//  Created by Ziyun Zheng on 11/27/16.
//
//

import Foundation
import CoreData


extension SavedRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRecipe> {
        return NSFetchRequest<SavedRecipe>(entityName: "SavedRecipe");
    }

    @NSManaged public var videoId: String?
    @NSManaged public var name: String?
    @NSManaged public var ingredients: [String:Bool]?

}
