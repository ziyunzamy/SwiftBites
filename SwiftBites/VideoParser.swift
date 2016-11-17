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
            if let vId = videoId,
                let thumb = thumbnail,
                let title = name {
                let video:Video = Video(videoId: vId, name: title, thumbnail: thumb)
                videos.append(video)
            }
        }
        return videos
    }
    
}
