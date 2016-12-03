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
        let videoId = recipeJSON["items"][0]["id"].string
        let name = recipeJSON["items"][0]["snippet"]["title"].string
        if let desc = description {
            if let vId = videoId,
                let title = name {
                let ingredients = getIngredientsList(description: desc)
                let ingredientsDict = makeDictionary(ingredients: ingredients)
                let recipe = Recipe(videoId: vId, name: title, ingredients: ingredientsDict, collapsed:true)
                return recipe
            }
        }
        return nil
        
    }
    func makeDictionary(ingredients: [String])-> [String:Bool]{
        var results: [String:Bool] = [:]
        for ing in ingredients {
            results[ing] = false
        }
        return results
    }
    
    func getIngredientsList(description: String) -> [String] {
        let startIndex:String.Index? = findIngredientsIndex(description: description)
        let endIndex:String.Index? = findPreparationIndex(description: description)
        
        let categories = ["filling", "crust", "pasta crust", "topping", "toppings", "dipping sauce", "chocolate mix", "cornbread stuffing", "tia's cornbread", "soup", "dumplings", "dressing", "salad", "bake", "broccoli", "cider sauce", "middle layer", "chocolate ganache", "sauce", "stuffing", "*chicken shake", "obatzda cheese mix", "pretzels", "garnish", "strudel", "vanilla pudding mixture", "garnish", "cabbage slaw", "caramel apple filling", "cilantro-lime yogurt sauce", "for the choux pastry:", "for the pastry cream:", "for the icing:", "brownie base", "chocolate mousse ice cream layer", ""]
        
        if let startIndex = startIndex,
            let endIndex = endIndex {
            // gets the string containing ingredients
            var ing = description[startIndex..<endIndex]
            // removes trailing, leading, and extra whitespaces
            ing = ing.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            // produces an array from the string
            let ingredients = ing.components(separatedBy: "\n")
            // filter out elements that are actually categories/titles not ingredients
            return ingredients.filter{!categories.contains($0.lowercased())}
        }
        return ["No ingredients available for this recipe."]
    }
    
    func findIngredientsIndex(description: String) -> String.Index? {
        var startIndex:String.Index?
        let possible = ["INGREDIENTS", "Ingredients", "Ingredients:"]
        let contains = possible.filter{description.contains($0)}
        if contains.count > 0 {
            if let index = description.range(of: contains[0]) {
                startIndex = index.upperBound
            }
        }
        return startIndex
    }
    
    func findPreparationIndex(description: String) -> String.Index? {
        var endIndex:String.Index?
        let possible = ["PREPARATION", "Preparation", "INSTRUCTIONS", "Instructions", "Instructions:"]
        let contains = possible.filter{description.contains($0)}
        if contains.count > 0 {
            if let index = description.range(of: contains[0]) {
                endIndex = index.lowerBound
            }
        }
        return endIndex
    }
    
}

