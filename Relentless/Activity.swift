//
//  Activity.swift
//  Relentless
//
//  Created by pixable on 6/16/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation

class Activity: AnyObject, Hashable {
    var name : String!
    var energyConsumer : Bool = true
    var hashValue : Int {
        get {
            return name.hashValue
        }
    }
}

func ==(lhs: Activity, rhs: Activity) -> Bool {
    return lhs.name == rhs.name
}