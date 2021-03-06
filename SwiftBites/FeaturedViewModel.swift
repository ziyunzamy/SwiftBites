//
//  FeaturedViewModel.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/9/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
class FeaturedViewModel{
    var videos = [Video]()
    let client = VideoClient()
    let parser = VideoParser()
    var searchTerm:String?
    func numberOfSection() -> Int {
        return videos.count
    }
    func nameForSectionAtIndexPath(indexPath: NSIndexPath) -> String {
        if indexPath.row >= self.videos.count{
            return ""
        }
        else{
            return self.videos[indexPath.row].name
        }
    }
    
    func detailViewModelForSectionAtIndexPath(indexPath: NSIndexPath) -> VideoDetailViewModel {
        let result = VideoDetailViewModel(video:self.videos[indexPath.row])
        return result
    }
    //load videos, pass in pageToken if user click loadmore
    func refresh(completion: @escaping () -> Void) {
        self.client.searchTerm = self.searchTerm
        client.fetchVideo { [unowned self] data in
            self.videos += self.parser.parseVideos(data: data!)
            self.client.pageToken = self.parser.parseNextPageToken(data: data!)
            completion()
        }
    }
}
