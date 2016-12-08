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
        XCTAssertEqual((recipe?.ingredients)!, ["20 medium-sized mushrooms":false, "1 tablespoon butter":false, "2 cloves garlic, minced":false, "4 cups fresh spinach":false,"8 ounces cream cheese":false,"Salt":false,"Pepper":false,"¼ cup bread crumbs":false,"¼ cup parmesan":false])
    }
    
    func test_parseVideos_withInvalidIngredients() {
        let data = loadJSONTestData(filename: "noingredients-response")
        let recipe = parser.parseRecipe(data: data!)
        XCTAssertNotNil(recipe)
        XCTAssertEqual(recipe?.videoId, "KLGSLCaksdY")
        XCTAssertEqual(recipe?.name, "How To Cook With Cast Iron")
        XCTAssertEqual((recipe?.ingredients)!, ["No ingredients available for this recipe.":false])
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
