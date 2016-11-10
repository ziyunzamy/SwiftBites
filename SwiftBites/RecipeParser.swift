//
//  RecipeParser.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser{
    init(){
        let videoString = "https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&part=snippet&id=3jj6QwaCQcU"
        
        let videoURL: NSURL = NSURL(string: videoString)!
        let videoData = NSData(contentsOf: videoURL as URL)!
        let videoJson = JSON(data: videoData as Data)
        
        var startIndex:String.Index?
        var endIndex:String.Index?
        
        let description = videoJson["items"][0]["snippet"]["description"].string
        
        let ingredientResult = description?.range(of: "INGREDIENTS")
        if let range = ingredientResult {
            startIndex = range.upperBound
        }
        
        let prepResult = description?.range(of: "PREPARATION")
        if let prepRange = prepResult {
            endIndex = prepRange.lowerBound
        }
        if let startIndex = startIndex,
            let endIndex = endIndex{
            var i = description?[startIndex..<endIndex]
            i = i?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let ingredients = i?.components(separatedBy: "\n")
            print(ingredients)
        }
        
     }
}

//class RecipeParser {
//    func parseRecipe(data: NSData) -> Recipe? {
//        let recipeJSON = JSON(data: data as Data)
//        
//        let videoId = recipeJSON["items"][0]["id"].string
//        let description = recipeJSON["items"][0]["snippet"]["description"].string
//        let name = recipeJSON["items"][0]["snippet"]["title"].string
//        let recipe = Recipe(videoId: videoId!, name: name!, ingredients: description!)
//        return recipe
//    }
//    
//}

