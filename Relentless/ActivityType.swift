//
//  ActivityType.swift
//  Relentless
//
//  Created by pixable on 7/11/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityType: NSObject, ParseWrapper {
    let name : String
    let isEnergyConsumer : Bool
    let iconFile : PFFile
    let object : PFObject
    
    private var parseCopyObject : PFObject?
    
    required init(object: PFObject) {
        name = object.valueForKey(Constants.Parameters.name) as? String ?? ""
        isEnergyConsumer = (object[Constants.Parameters.isEnergyConsumer] as? NSNumber)?.boolValue ?? false
        iconFile = object[Constants.Parameters.icon] as! PFFile
        self.object = object
        super.init()
    }
    
    class func parse(objects: [PFObject]) -> [ActivityType] {
        var activityTypes : [ActivityType] = []
        for object in objects {
            activityTypes.append(ActivityType(object: object))
        }
        return activityTypes
    }
    
    class func createActivities(activityTypes: [ActivityType], completion: (Bool, [Activity]) -> Void) {
        var activityObjects : [PFObject ] = []
        for activityType in activityTypes {
            let activityObject = PFObject(className: Constants.Classes.Activity)
            activityObject[Constants.Parameters.type] = activityType.object
            activityObject[Constants.Parameters.name] = "\(activityType.name) Activity"
            activityObjects.append(activityObject)
        }
        PFObject.saveAllInBackground(activityObjects, block: { (succeeded, _) -> Void in
            completion(succeeded, succeeded ? Activity.parse(activityObjects) : [])
        })
    }
    
}
