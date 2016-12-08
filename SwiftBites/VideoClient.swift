//
//  VideoClient.swift
//  SwiftBites
//
//  Created by Karen Miriam Segal on 11/8/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation

/// Handles network call for videos
class VideoClient {
    /// Optional pageToken that can be passed into channel url
    var pageToken:String?
    var searchTerm:String?
    /**
     
     Fetches videos from Tasty Channel using [YouTube Search API](https://developers.google.com/youtube/v3/docs/search) .
     
     - parameter completion: completion handler that returns videos as JSON.
     
     */
    func fetchVideo(completion: @escaping (NSData?) -> Void) {
        /// tasty channel URL
        var channelUrlString = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAbJzDWQo7GXNqBh89ZpqIf88Dc03wfdZM&channelId=UCJFp8uSYCjXOMnkUyb3CQ3Q&part=snippet,id&order=date&maxResults=50"
        if let pageToken = self.pageToken {
            channelUrlString += "&pageToken=" + pageToken
        }
        if let searchTerm = self.searchTerm {
            channelUrlString += "&q=" + searchTerm
        }
        
        guard let channelURL = NSURL(string: channelUrlString) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with:channelURL as URL) { data, response, error in
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
