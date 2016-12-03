//
//  VideoDetailViewModel.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
class VideoDetailViewModel {
    var ingredients = [String:Bool]()
    let video:Video
    let parser = RecipeParser()

    init (video: Video) {
        self.video = video
    }
    func videoId() -> String? {
        return self.video.videoId
    }
    func name() -> String? {
        return self.video.name
    }
    func isSaved() -> Bool {
        return self.video.saved
    }
    func thumbnail() -> String? {
        return self.video.thumbnail
    }
    func getIngredients() ->[String:Bool] {
        return self.ingredients
    }
    
    func numberOfIngredients() -> Int {
        return ingredients.count
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < ingredients.count {
            let keys = Array(ingredients.keys)
            return keys[index]
        }
        return ""
    }
    
    func refresh(completion: @escaping () -> Void) {
        let client = RecipeClient(videoId: self.videoId()!)
        client.fetchRecipes { [unowned self] data in
            self.ingredients = (self.parser.parseRecipe(data: data!)?.ingredients)!
            completion()
        }
    }
}
