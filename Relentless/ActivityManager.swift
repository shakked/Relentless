//
//  ActivityManager.swift
//  Relentless
//
//  Created by pixable on 6/16/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

//import UIKit
//
//class ActivityManager: NSObject {
//    static let sharedManager = ActivityManager()
//    var activityEvents : [ActivityEvent] = []
//
//    class func allActivities() -> [Activity] {
//        return [Weights(), Cardio()]
//    }
//    
//    func activityEvent(date: NSDate) -> ActivityEvent {
//        for activityEvent in activityEvents {
//            //if event is today -> event
//        }
//        return ActivityEvent(date: date)
//    }
//    
//}

import UIKit

class ActivityManager: NSObject {
    
//    init(date: NSDate) {
//        
//    }
//    
//    class func allActivities() -> [Activity] {
//        return ActivityStore.sharedStore().allActivities() as! [Activity]
//    }
//    
//    class func activitiesForDate(date: NSDate) -> [Activity] {
//        let calendar = NSCalendar.currentCalendar()
//        var activities : [Activity] = []
//        for activity in allActivities() {
//            if calendar.isDate(activity.date, inSameDayAsDate: date) {
//                activities.append(activity)
//            }
//        }
//        return activities
//    }
//    
//    class func hasEnergyConsumer(activities: [Activity]) -> Bool {
//        for activity in activities {
//            if activity.type.integerValue == ExerciseType.EnergyConsumer.rawValue {
//                return true
//            }
//        }
//        return false
//    }
//    
//    class func hasNonEnergyConsumer(activities: [Activity]) -> Bool {
//        for activity in activities {
//            if activity.type.integerValue == ExerciseType.NonEnergyConsumer.rawValue {
//                return true
//            }
//        }
//        return false
//    }
//    
//    class func removeEnergyConsumers(activities: [Activity]) {
//        for activity in activities {
//            if activity.type.integerValue == ExerciseType.EnergyConsumer.rawValue {
//                ActivityStore.sharedStore().deleteActivity(activity)
//            }
//        }
//    }
//    
//    class func addRest(date: NSDate) {
//        let restActivity = ActivityStore.sharedStore().createActivity()
//        restActivity.date = date
//        restActivity.name = "Rest"
//        restActivity.type = NSNumber(integer: ExerciseType.NonEnergyConsumer.rawValue)
//    }
//    
//    class func removeRest(date: NSDate) {
//        
//    }

}

enum ExerciseType: Int {
    case NonEnergyConsumer = 0
    case EnergyConsumer = 1
    
}

