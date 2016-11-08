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
        let channelURL: NSURL = NSURL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&channelId=UCJFp8uSYCjXOMnkUyb3CQ3Q&part=snippet,id&order=date&maxResults=10")!
        var videoString = "https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&part=snippet&id="
        
        let channelData = NSData(contentsOf: channelURL as URL)!
        let channelJson = JSON(data: channelData as Data)
        
        print(channelJson["items"][0]["snippet"]["thumbnails"]["default"]["url"]) // image
        print(channelJson["items"][0]["snippet"]["title"]) // name
        print(channelJson["items"][0]["snippet"]["description"]) // description
        print(channelJson["items"][0]["snippet"]["publishedAt"]) // date
        let videoId = channelJson["items"][0]["id"]["videoId"].string // videoId
        if let videoId = videoId {
            videoString = videoString + videoId
            let videoURL: NSURL = NSURL(string: videoString)!
            let videoData = NSData(contentsOf: videoURL as URL)!
            let videoJson = JSON(data: videoData as Data)
            
            print(videoJson["items"][0]["snippet"]["description"])
        }
    
     }
}
