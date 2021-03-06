//
//  extensions.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 12/2/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//  ideas & code snippets partially taken from "https://github.com/jeantimex/ios-swift-collapsible-table-section"
//
import UIKit

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIView {
    /*
     // MARK: - Rotate the arrow to identify collapse statue
     */
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}
