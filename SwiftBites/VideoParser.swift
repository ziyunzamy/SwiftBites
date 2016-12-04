//
//  VideoParser.swift
//  SwiftBites
//
//  Created by Karen Miriam Segal on 11/8/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
import SwiftyJSON

/// handles parsing of video JSON data received from VideoClient
class VideoParser {
    /**
     
     Parses JSON into list of video objects
     - parameter data: videoJSON received from VideoClient
     - returns: array of videos
     
     */
    func parseVideos(data: NSData) -> [Video] {
        var videos = [Video]()
        let videoJSON = JSON(data: data as Data)
        for i in 0..<videoJSON["items"].count {
            let videoId = videoJSON["items"][i]["id"]["videoId"].string
            let thumbnail = videoJSON["items"][i]["snippet"]["thumbnails"]["medium"]["url"].string
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
    /**
     
     Finds the nextPageToken of the channel because YouTube API limits returning 50 videos at a time
     - parameter data: videoJSON received from VideoClient
     - returns: nextPageToken if it exists
     
     */
    func parseNextPageToken(data: NSData) -> String? {
        let videoJSON = JSON(data: data as Data)
        let pageToken = videoJSON["nextPageToken"].string
        if let token = pageToken {
            return token
        }
        else {
            return nil
        }
    }
    
}
