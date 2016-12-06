//
//  Video.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

/// Video used in FeaturedView
struct Video {
    /// unique identifier for video that relates it to recipe information
    let videoId: String
    /// recipe title
    let name: String
    /// url containing static image of recipe
    let thumbnail: String
    /// indicates whether recipe is in savedview
    let saved:Bool = false
}
