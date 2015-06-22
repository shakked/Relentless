//
//  ActivityEvent.swift
//  Relentless
//
//  Created by pixable on 6/16/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityEvent: NSObject, Printable {
    var date : NSDate
    internal var activities : Set<Activity> = []
    
    override var description: String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .FullStyle
        let dateString = dateFormatter.stringFromDate(date)
        var description = "\(dateString):"
        for activity in activities {
            description = description.stringByAppendingString(" \(activity.name)")
        }
        return description
    }
    
    init(date: NSDate) {
        self.date = date
        super.init()
    }
    
    func has(activity: Activity) -> Bool {
        for the_activity in self.activities {
            if the_activity.name == activity.name {
                return true
            }
        }
        return false
    }
    
    func add(activity: Activity) {
        activities.insert(activity)
        println(self)
    }
    
    func remove(activity: Activity) {
        activities.remove(activity)
        println(self)
    }
    
    func removeAll() {
        activities.removeAll(keepCapacity: false)
    }
    
    func removeAllEnergyConsumers() {
        for activity in activities {
            if activity.energyConsumer {
                activities.remove(activity)
            }
        }
    }
    
    func hasEnergyConsumer() -> Bool {
        for activity in activities {
            if activity.energyConsumer {
                return true
            }
        }
        return false
    }
}