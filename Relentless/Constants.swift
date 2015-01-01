//
//  Constants.swift
//  Relentless
//
//  Created by pixable on 7/11/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

struct Constants {
    struct Classes {
        static let ActivityEvent = "ActivityEvent"
        static let Activity = "Activity"
        static let ActivityType = "ActivityType"
    }
    
    struct Views {
        static let StreakView = "StreakView"
        static let DoneCancelView = "DoneCancelView"
        static let HeaderView = "HeaderView"
        static let ParallaxHeaderView = "ParallaxHeaderView"
    }
    
    struct Cells {
        static let ActivityCell = "ActivityCell"
        static let ActivityTypeCell = "ActivityTypeCell"
        static let ProfileCardCell = "ProfileCardCell"
    }
    
    struct Parameters {
        static let date = "date"
        static let user = "user"
        static let name = "name"
        static let activities = "activities"
        static let isEnergyConsumer = "isEnergyConsumer"
        static let isDefault = "isDefault"
        static let type = "type"
        static let icon = "icon"
        static let activityEvent = "activityEvent"
        static let activityType = "activityType"
        static let explanation = "explanation"
        static let longestStreak = "longestStreak"
    }
    
    struct ActivityType {
        static let rest = "rest"
    }
}
