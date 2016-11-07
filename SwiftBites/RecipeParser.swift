//
//  RecipeParser.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
import SwiftyJSON
//get the json response from network
//parse the ingredidents and put those into Recipe.swift model(videoID,name,ingredients)
//parse the attrributes related to the video--(videoID, thumbnail,name)
class Parser{
    init(){
        let youtubeURL: NSURL = NSURL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&channelId=UCJFp8uSYCjXOMnkUyb3CQ3Q&part=snippet,id&order=date&maxResults=10")!
        
        let data = NSData(contentsOf: youtubeURL as URL)!
        let json = JSON(data: data as Data)
        
        print(json["items"][0]["snippet"]["thumbnails"]["default"])
    }
}
