//
//  ActivityEvent.swift
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//
//
import Foundation


class ActivityEvent: NSObject, ParseWrapper {
    let date : NSDate
    var activities : [Activity]
    let object : PFObject?
    
    //MARK:- Initialization
    required init(object: PFObject) {
        date = object[Constants.Parameters.date] as! NSDate
        let objects = object[Constants.Parameters.activities] as? [PFObject] ?? []
        
        activities = Activity.parse(objects)
        self.object = object
        super.init()
    }
    
    private override init() {
        date = NSDate()
        activities = []
        self.object = nil
    }
    
    class func empty() -> ActivityEvent {
        return ActivityEvent()
    }
    
    //MARK:- Multiple Object Initialization

    class func parse(objects: [PFObject]) -> [ActivityEvent] {
        var activityEvents : [ActivityEvent] = []
        for object in objects {
            activityEvents.append(ActivityEvent(object: object))
        }
        return activityEvents
    }
    
    //MARK:- Useful Data Inquiring Function
    
    func hasEnergyConsumer() -> Bool {
        for activity in activities {
            if activity.type.isEnergyConsumer {
                return true
            }
        }
        return false
    }
    
    func hasActivityTypeWithName(name: String) -> Bool {
        for activity in activities {
            if activity.type.name == name {
                return true
            }
        }
        return false
    }
    
    //MARK:- Adding/Removing Activities
    
    func addActivities(activities: [Activity]) {
        self.activities += activities
        var activityObjects : [PFObject] = []
        for activity in activities {
            activityObjects.append(activity.object)
        }
        object?.addObjectsFromArray(activityObjects, forKey: Constants.Parameters.activities)
        object?.saveEventually({ _ in })
    }
}