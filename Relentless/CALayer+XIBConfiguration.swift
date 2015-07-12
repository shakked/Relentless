//
//  CALayer+XIBConfiguration.swift
//  Talking Joke Generator
//
//  Created by pixable on 7/2/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation

extension CALayer {
    var borderUIColor : UIColor {
        set {
            borderColor = newValue.CGColor
        }
        get {
            return UIColor(CGColor: borderColor)!
        }
    }
    var shadowUIColor : UIColor {
        set {
            shadowColor = newValue.CGColor
        }
        get {
            return UIColor(CGColor: shadowColor)!
        }
    }
    
}
