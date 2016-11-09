//
//  RecipeClient.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation

class RecipeClient {
    let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    func fetchRecipes(completion: @escaping (NSData?) -> Void) {
        var videoURLString = "https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&part=snippet&id="
        videoURLString = videoURLString + videoId
        
        guard let recipeURL = NSURL(string: videoURLString) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with:recipeURL as URL) { data, response, error in
            if let error = error {
                print("Error fetching channel: \(error)")
                completion(data as NSData?)
                return
            }
            
            completion(data as NSData?)
        }
        task.resume()
    }
    
}
