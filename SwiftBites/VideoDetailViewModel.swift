//
//  VideoDetailViewModel.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
class VideoDetailViewModel {
    let video:Video
    // your code here
    init (video: Video) {
        self.video = video
    }
    func videoId() -> String? {
        return self.video.videoId
    }
    func name() -> String? {
        return self.video.name
    }
}
