//
//  RecipeParserTests.swift
//  SwiftBites
//
//  Created by Karen Miriam Segal on 11/24/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import XCTest

@testable import SwiftBites
@testable import SwiftyJSON

class RecipeParserTests: XCTestCase {
    let parser = RecipeParser()
    
    func test_parseVideos() {
        let data = loadJSONTestData(filename: "recipe-response")
        let recipe = parser.parseRecipe(data: data!)
        XCTAssertNotNil(recipe)
        XCTAssertEqual(recipe?.videoId, "piRCiB2Zm-Y")
        XCTAssertEqual(recipe?.name, "Creamy Spinach-Stuffed Mushrooms")
        XCTAssertEqual((recipe?.ingredients)!, ["20 medium-sized mushrooms", "1 tablespoon butter", "2 cloves garlic, minced", "4 cups fresh spinach","8 ounces cream cheese","Salt","Pepper","¼ cup bread crumbs","¼ cup parmesan"])
    }
    
    func test_parseVideos_withInvalidIngredients() {
        let data = loadJSONTestData(filename: "noingredients-response")
        let recipe = parser.parseRecipe(data: data!)
        XCTAssertNotNil(recipe)
        XCTAssertEqual(recipe?.videoId, "KLGSLCaksdY")
        XCTAssertEqual(recipe?.name, "How To Cook With Cast Iron")
        XCTAssertEqual((recipe?.ingredients)!, ["No ingredients available for this recipe."])
    }
    
    func test_parseVideos_withInvalidRecipe() {
        let data = loadJSONTestData(filename: "invalid-response")
        let recipe = parser.parseRecipe(data: data!)
        XCTAssertNil(recipe)
        
    }
    
    // for testing purposes only
    func loadJSONTestData(filename: String) -> NSData? {
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: filename, ofType: "json")
        return NSData(contentsOfFile: path!)
    }
}
