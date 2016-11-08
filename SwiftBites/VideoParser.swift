//
//  VideoParser.swift
//  SwiftBites
//
//  Created by Karen Miriam Segal on 11/8/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoParser {
    func parseVideos(data: NSData) -> [Video]? {
        var videos = [Video]()
        let videoJSON = JSON(data: data as Data)
        for i in 0..<data.length {
            let videoId = channelJson["items"][i]["id"]["videoId"].string
            let thumbnail = channelJson["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
            let name = channelJson["items"][i]["snippet"]["title"].string
            
            let video:Video = Video(videoId: videoId, name:name, thumbnail:thumbnail)
            videos.append(video: Video)
        }
        return videos
    }
    
}
