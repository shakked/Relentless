//
//  ActivityEvent.swift
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//
//
import Foundation


class ActivityEvent: NSObject {
    let date : NSDate
    var activities : [Activity]
    let object : PFObject?
    
    init(object: PFObject) {
        date = object.valueForKey(Constants.Parameters.date) as! NSDate
        let objects = object.valueForKey(Constants.Parameters.activities) as? [PFObject] ?? []
        
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

    class func parse(objects: [PFObject]) -> [ActivityEvent] {
        var activityEvents : [ActivityEvent] = []
        for object in objects {
            activityEvents.append(ActivityEvent(object: object))
        }
        return activityEvents
    }
    
    func hasEnergyConsumer() -> Bool {
        for activity in activities {
            if activity.type.isEnergyConsumer {
                return true
            }
        }
        return false
    }
    
    //fix
    func hasActivityTypeWithName(name: String) -> Bool {
        for activity in activities {
            if activity.type.name == name {
                return true
            }
        }
        return false
    }
    
    func addActivity(name: String, isEnergyConsumer: Bool) {
        let activityObject = PFObject(className: Constants.Classes.Activity)
        activityObject[Constants.Parameters.name] = name
        activityObject[Constants.Parameters.isEnergyConsumer] = NSNumber(bool: isEnergyConsumer)
        activityObject.saveEventually { _ in }
    }
    
    func addActivities(activities: [Activity]) {
        self.activities += activities
        var activityObjects : [PFObject] = []
        for activity in activities {
            activityObjects.append(activity.object)
        }
        object?.addObjectsFromArray(activityObjects, forKey: Constants.Parameters.activities)
        object?.saveEventually({ _ in })
    }
    
    func removeActivityTypeWithName(name: String, completion: (Bool) -> (Void)) {
        for activity in activities {
            if activity.type.name == name {
                activities.removeObject(activity)
                PFObject(withoutDataWithObjectId: activity.object.objectId).deleteInBackgroundWithBlock({ (succeeded, _) -> Void in
                    completion(succeeded)
                })
                break
            }
        }
    }
    
    func removeEnergyConsumers(completion: (Bool) -> (Void)) {
        var activityObjectIdsToRemove : [String] = []
        for activity in self.activities {
            if activity.type.isEnergyConsumer {
                activityObjectIdsToRemove.append(activity.object.objectId!)
                activities.removeObject(activity)
            }
        }
        let activityObjects : [PFObject] = PFObject.objectify(activityObjectIdsToRemove)
        PFObject.deleteAllInBackground(activityObjects, block: { (succeeded, _) -> Void in
            completion(succeeded)
        })
    }
    
    

    
    
}

//    override var description: String{
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeStyle = .NoStyle
//        dateFormatter.dateStyle = .FullStyle
//        let dateString = dateFormatter.stringFromDate(date)
//        var description = "\(dateString):"
//        for activity in activities {
//            description = description.stringByAppendingString(" \(activity.name)")
//        }
//        return description
//    }
//    
//    func hasEnergyConsumers() -> Bool {
//        let activities = self.activities as! Set<Activity>
//        for activity in activities {
//            if activity.energyConsumer.boolValue == true {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func removeEnergyConsumers() {
//        let activities = self.activities as! Set<Activity>
//        for activity in activities {
//            if activity.energyConsumer.boolValue == true {
//                ActivityStore.sharedStore().deleteActivity(activity)
//            }
//        }
//    }
//    
//    func addActivity(name: String, isEnergyConsumer: Bool) {
//        let activity = ActivityStore.sharedStore().createActivity()
//        activity.name = name
//        activity.energyConsumer = NSNumber(bool: isEnergyConsumer)
//        activity.activityEvent = self
//        println("Added \(activity.name): \(self)")
//    }
//    
//    func removeActivity(activityName: String) {
//        let activities = self.activities as! Set<Activity>
//        for activity in activities {
//            if activity.name == activityName {
//                ActivityStore.sharedStore().deleteActivity(activity)
//            }
//        }
//        println(self)
//    }
//    
//    func addRest() {
//        removeEnergyConsumers()
//        let activity = ActivityStore.sharedStore().createActivity()
//        activity.name = "Rest"
//        activity.activityEvent = self
//        activity.energyConsumer = NSNumber(bool: false)
//        println("Added Rest: \(self)")
//    }
//    
//    func removeRest() {
//        removeActivity("Rest")
//    }
//    
//    func has(activityName: String) -> Bool {
//        let activities = self.activities as! Set<Activity>
//        for activity in activities {
//            if activity.name == activityName {
//                println("Do I have \(activityName): Yes")
//                return true
//            }
//        }
//        println("Do I have \(activityName): No")
//        return false
//    }
//    
//    class func defaultActivities() -> [String] {
//        return ["Weights", "Cardio", "Yoga"]
//    }

