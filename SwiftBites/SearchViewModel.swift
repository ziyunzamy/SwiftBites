//
//  SearchViewModel.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 12/8/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import Foundation
class SearchViewModel{
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
    
    func refresh(completion: @escaping () -> Void) {
        client.fetchVideo { [unowned self] data in
            self.videos += self.parser.parseVideos(data: data!)
            self.client.searchTerm = self.searchTerm
            self.client.pageToken = self.parser.parseNextPageToken(data: data!)
            completion()
        }
    }
}
