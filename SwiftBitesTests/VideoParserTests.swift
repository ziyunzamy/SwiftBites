//
//  VideoParserTests.swift
//  SwiftBites
//
//  Created by Karen Miriam Segal on 11/21/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import XCTest

@testable import SwiftBites
@testable import SwiftyJSON

class VideoParserTests: XCTestCase {
    let parser = VideoParser()
    
    func test_parseVideos() {
        let data = loadJSONTestData(filename: "videos-response")
        let results = parser.parseVideos(data: data!)
        XCTAssertNotNil(results)
        let first = results.first!
        XCTAssertEqual("Mini Sweet Potato Pies", first.name)
        XCTAssertEqual("1qL0DFEFGpE", first.videoId)
        XCTAssertEqual("https://i.ytimg.com/vi/1qL0DFEFGpE/default.jpg", first.thumbnail)
    }
    
    // for testing purposes only
    func loadJSONTestData(filename: String) -> NSData? {
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: filename, ofType: "json")
        return NSData(contentsOfFile: path!)
    }
}
