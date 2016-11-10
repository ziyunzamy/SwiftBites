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
        for i in 0..<videoJSON["items"].count {
            let videoId = videoJSON["items"][i]["id"]["videoId"].string
            let thumbnail = videoJSON["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
            let name = videoJSON["items"][i]["snippet"]["title"].string
            let video:Video = Video(videoId: videoId! as String, name:name! as String, thumbnail:thumbnail! as String)
            videos.append(video)
        }
        return videos
    }
    
}
