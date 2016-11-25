//
//  VideoDetailViewModel.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
class VideoDetailViewModel {
    var ingredients = [String]()
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
    
    func numberOfIngredients() -> Int {
        return ingredients.count
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < ingredients.count {
            return ingredients[index]
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
