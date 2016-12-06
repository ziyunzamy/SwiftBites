//
//  Recipe.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/7/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

struct Recipe {
    let videoId: String
    let name: String
    var ingredients: [String:Bool]
    let saved:Bool = false
    var collapsed: Bool = true
}
