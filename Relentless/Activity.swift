//
//  Activity.swift
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import Foundation
import CoreData


class Activity: NSManagedObject {

    @NSManaged var energyConsumer: NSNumber
    @NSManaged var name: String
    @NSManaged var activityEvent: NSManagedObject
    

}
