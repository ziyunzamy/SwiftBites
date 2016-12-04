//
//  Recipe.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

/// Recipe used in RecipeDetailView
struct Recipe {
    /// unique identifier for recipe
    let videoId: String
    /// title of recipe
    let name: String
    /// list of ingredients needed to make the recipe
    let ingredients: [String]
    /// indicates whether ingredients are saved to shopping list
    let saved:Bool = false
}
