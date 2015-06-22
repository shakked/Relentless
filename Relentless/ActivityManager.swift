//
//  ActivityManager.swift
//  Relentless
//
//  Created by pixable on 6/16/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityManager: NSObject {
    static let sharedManager = ActivityManager()
    var activityEvents : [ActivityEvent] = []

    class func allActivities() -> [Activity] {
        return [Weights(), Cardio()]
    }
    
    func activityEvent(date: NSDate) -> ActivityEvent {
        for activityEvent in activityEvents {
            //if event is today -> event
        }
        return ActivityEvent(date: date)
    }
    
}
