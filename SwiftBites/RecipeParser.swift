//
//  RecipeParser.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecipeParser {
    func parseRecipe(data: NSData) -> Recipe? {
        let recipeJSON = JSON(data: data as Data)
        
        let videoId = recipeJSON["items"][0]["id"].string
        let description = recipeJSON["items"][0]["snippet"]["description"].string
        let name = recipeJSON["items"][0]["snippet"]["title"].string
        let recipe = Recipe(videoId: videoId!, name: name!, ingredients: description!)
        return recipe
    }
    
}

