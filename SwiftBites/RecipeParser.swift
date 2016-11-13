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
        
        
        let description = recipeJSON["items"][0]["snippet"]["description"].string
        if let description = description,
            let videoId = recipeJSON["items"][0]["id"].string,
            let name = recipeJSON["items"][0]["snippet"]["title"].string,
            let ingredients = getIngredientsList(description: description) {
                let recipe = Recipe(videoId: videoId, name: name, ingredients: ingredients)
                return recipe
        }
        return nil
        
    }
    
    func getIngredientsList(description: String) -> [String]? {
        var startIndex:String.Index?
        var endIndex:String.Index?
        
        let ingredientResult = description.range(of: "INGREDIENTS")
        if let range = ingredientResult {
            startIndex = range.upperBound
        }
        let prepResult = description.range(of: "PREPARATION")
        if let prepRange = prepResult {
            endIndex = prepRange.lowerBound
        }
        let categories = ["filling", "crust", "pasta crust", "topping", "toppings", "dipping sauce", "chocolate mix", "cornbread stuffing", "tia's cornbread", "soup", "dumplings", "dressing", "salad", "bake", "broccoli", "cider sauce", "middle layer", "chocolate ganache", "sauce", "stuffing", "*chicken shake", "obatzda cheese mix", "pretzels", "garnish", "strudel", "vanilla pudding mixture", "garnish", "cabbage slaw", "caramel apple filling", "cilantro-lime yogurt sauce", "for the choux pastry:", "for the pastry cream:", "for the icing:", ""]
        if let startIndex = startIndex,
            let endIndex = endIndex{
            var ing = description[startIndex..<endIndex]
            ing = ing.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let ingredients = ing.components(separatedBy: "\n")
            return ingredients.filter{!categories.contains($0.lowercased())}
        }
        return nil
    }
    
}

