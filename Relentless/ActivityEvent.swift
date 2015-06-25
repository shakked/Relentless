//
//  ActivityEvent.swift
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation
import CoreData



class ActivityEvent: NSManagedObject, Printable {

    @NSManaged var date: NSDate
    @NSManaged var activities: NSSet

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
    
    func hasEnergyConsumers() -> Bool {
        let activities = self.activities as! Set<Activity>
        for activity in activities {
            if activity.energyConsumer.boolValue == true {
                return true
            }
        }
        return false
    }
    
    func removeEnergyConsumers() {
        let activities = self.activities as! Set<Activity>
        for activity in activities {
            if activity.energyConsumer.boolValue == true {
                ActivityStore.sharedStore().deleteActivity(activity)
            }
        }
    }
    
    func addActivity(name: String, isEnergyConsumer: Bool) {
        let activity = ActivityStore.sharedStore().createActivity()
        activity.name = name
        activity.energyConsumer = NSNumber(bool: isEnergyConsumer)
        activity.activityEvent = self
        println("Added \(activity.name): \(self)")
    }
    
    func removeActivity(activityName: String) {
        let activities = self.activities as! Set<Activity>
        for activity in activities {
            if activity.name == activityName {
                ActivityStore.sharedStore().deleteActivity(activity)
            }
        }
        println(self)
    }
    
    func addRest() {
        removeEnergyConsumers()
        let activity = ActivityStore.sharedStore().createActivity()
        activity.name = "Rest"
        activity.activityEvent = self
        activity.energyConsumer = NSNumber(bool: false)
        println("Added Rest: \(self)")
    }
    
    func removeRest() {
        removeActivity("Rest")
    }
    
    func has(activityName: String) -> Bool {
        let activities = self.activities as! Set<Activity>
        for activity in activities {
            if activity.name == activityName {
                println("Do I have \(activityName): Yes")
                return true
            }
        }
        println("Do I have \(activityName): No")
        return false
    }
    
    class func defaultActivities() -> [String] {
        return ["Weights", "Cardio", "Yoga"]
    }
    
}
