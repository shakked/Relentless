//
//  Activity.swift
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation
import CoreData


class Activity: NSObject, ParseWrapper {
    let name : String
    let type : ActivityType
    let date : NSDate
    let object : PFObject
    
    required init(object: PFObject) {
        
        name = object[Constants.Parameters.name] as? String ?? ""
        type = ActivityType(object: object[Constants.Parameters.type] as! PFObject)
        date = object[Constants.Parameters.date] as! NSDate
        self.object = object
        super.init()
    }
    
    class func parse(objects: [PFObject]) -> [Activity] {

        var activities : [Activity] = []
        for object in objects {
            let activity = Activity(object: object)
            activities.append(activity)
        }
        return activities
    }
}
