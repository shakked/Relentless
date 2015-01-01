

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
        query.includeKey("\(Constants.Parameters.activities).type")
        query.getFirstObjectInBackgroundWithBlock { (activityEventObject: PFObject?, error: NSError?) -> Void in
            println(activityEventObject)
            let activityEventObject = activityEventObject ?? self.createActivityEventObject(date)
            let activityEvent = ActivityEvent(object: activityEventObject)
            completion(activityEvent)
        }
    }
    
    private func createActivityEventObject(date: NSDate) -> PFObject {
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
    
    func activitesInformation(completion: (Int, ActivityType?) -> (Void)) {
        let query = PFQuery(className: Constants.Classes.ActivityEvent)
        query.whereKey(Constants.Parameters.user, equalTo: PFUser.currentUser()!)
        query.includeKey(Constants.Parameters.activities)
        query.includeKey("\(Constants.Parameters.activities).type")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                let objects = objects as? [PFObject] ?? []
                let activityEvents = ActivityEvent.parse(objects)
                var activities : [Activity] = []
                for activityEvent in activityEvents {
                    activities += activityEvent.activities
                }
                
                
                var activityTypeCounts = Dictionary<ActivityType,Int>()
                for activity in activities {
                    if activityTypeCounts[activity.type] == nil {
                        activityTypeCounts[activity.type] = 1
                    } else {
                        var currentCount = activityTypeCounts[activity.type]!
                        activityTypeCounts[activity.type] = ++currentCount
                    }
                }
                
                var mostFrequentActivityType : ActivityType!
                var currentFrequency = 0
                for (activityType, frequency) in activityTypeCounts {
                    if frequency > currentFrequency {
                        currentFrequency = frequency
                        mostFrequentActivityType = activityType
                    }
                }
            
                completion(activities.count, mostFrequentActivityType)
            } else {
                completion(0, nil)
            }
        }
        
        
    }
    
    func calculateAndSaveStreak(completion: ((Int, Bool) -> Void)) {
        let query = PFQuery(className: Constants.Classes.ActivityEvent)
        query.whereKey(Constants.Parameters.user, equalTo: PFUser.currentUser()!)
        query.whereKey(Constants.Parameters.date, lessThanOrEqualTo: NSDate.tomorrowMidnight())
        query.includeKey(Constants.Parameters.activities)
        query.includeKey("\(Constants.Parameters.activities).type")
        query.orderByDescending(Constants.Parameters.date)
        query.findObjectsInBackgroundWithBlock { (activityEventObjects, error: NSError?) -> Void in
            if error == nil {
                
                let activityEventObjects = activityEventObjects as! [PFObject]
                let activityEvents = ActivityEvent.parse(activityEventObjects)
                var date = NSDate()
                var streak : Int = 0
                let calendar = NSCalendar.currentCalendar()
                for activityEvent in activityEvents {
                    if activityEvent.activities.count > 0 && calendar.isDate(date, inSameDayAsDate: activityEvent.date) {
                        streak++
                    } else {
                        break
                    }
                    date = date.dateByAddingTimeInterval(-24*60*60)
                }
                
                PFUser.currentUser()!.fetchInBackgroundWithBlock({ (user: PFObject?, _) -> Void in
                    if let user = user {
                        let longestStreak = (user[Constants.Parameters.longestStreak] as? Int) ?? 0
                        if streak > longestStreak {
                            user[Constants.Parameters.longestStreak] = streak
                            user.saveInBackgroundWithBlock({ (succeeded, _) -> Void in
                                completion(streak, succeeded)
                            })
                        } else {
                            completion(streak, true)
                        }
                    } else {
                        println("here")
                        completion(streak, false)
                    }
                })
            } else {
                completion(0, false)
            }
        }
    }
    
}

enum ExerciseType: Int {
    case NonEnergyConsumer = 0
    case EnergyConsumer = 1
    
}

