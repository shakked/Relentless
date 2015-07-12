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
    
    static let sharedManager = ActivityManager()
    
    func activityEvent(date: NSDate, completion: (ActivityEvent) -> (Void)) {
        let midnights = date.midnights()
        let query = PFQuery(className: Constants.Classes.ActivityEvent)
        query.whereKey(Constants.Parameters.date, greaterThanOrEqualTo: midnights.dayOf)
        query.whereKey(Constants.Parameters.date, lessThan: midnights.nextDay)
        query.whereKey(Constants.Parameters.user, equalTo: PFUser.currentUser()!)
        query.includeKey(Constants.Parameters.activities)
        query.includeKey(Constants.Parameters.type)
        query.getFirstObjectInBackgroundWithBlock { (activityEventObject: PFObject?, error: NSError?) -> Void in
            let activityEventObject = activityEventObject ?? self.createActivityEventObject(date)
            completion(ActivityEvent(object: activityEventObject))
        }
    }
    
    func createActivityEventObject(date: NSDate) -> PFObject {
        let activityEventObject = PFObject(className: Constants.Classes.ActivityEvent)
        activityEventObject.setValue(date, forKey: Constants.Parameters.date)
        activityEventObject.setValue(PFUser.currentUser(), forKey: Constants.Parameters.user)
        activityEventObject.saveEventually { _ in }
        return activityEventObject
    }
    
    func activityTypesThatConsumeEnergy(completion: (([ActivityType], Bool) -> Void)) {
        let query = PFQuery(className: Constants.Classes.ActivityType)
        query.whereKey(Constants.Parameters.isEnergyConsumer, equalTo: true)
        query.findObjectsInBackgroundWithBlock { (activityTypeObjects, error) -> Void in
            if error == nil {
                let activityTypeObjects = activityTypeObjects as? [PFObject] ?? []
                let activityTypes = ActivityType.parse(activityTypeObjects)
                completion(activityTypes, true)
            } else {
                completion([], false)
            }
        }
    }
    
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

