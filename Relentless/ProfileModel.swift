//
//  ProfileModel.swift
//  Relentless
//
//  Created by pixable on 7/15/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    static let sharedModel = ProfileModel()
    func profileItems() -> [ProfileItem] {
        return [TotalActivities(), FavoriteActivityType(), LongestStreak()]
    }
}

protocol ProfileItem {
    func getItemInformation(completion: (iconImage: UIImage, title: String, description: String) -> (Void))
}

struct TotalActivities: ProfileItem {
    func getItemInformation(completion: (iconImage: UIImage, title: String, description: String) -> (Void)) {
        ActivityManager.sharedManager.activitesInformation { (activitiesCount: Int, _) -> (Void) in
            let iconImage = UIImage(named: "TotalActivitiesIcon")!
            let title = "\(activitiesCount) Total Activities"
            let description = "You've completed over \(activitiesCount) activities. Keep it up"
            completion(iconImage: iconImage, title: title, description: description)
        }
    }
}

struct FavoriteActivityType: ProfileItem {
    func getItemInformation(completion: (iconImage: UIImage, title: String, description: String) -> (Void)) {
        ActivityManager.sharedManager.activitesInformation { (_, activityType: ActivityType?) -> (Void) in
            let iconImage = UIImage(named: "FavoriteActivityTypeIcon")!
            if let activityType = activityType {
                let title = "\(activityType.name)"
                let description = "Clearly, you really enjoy \(activityType.name)"
                activityType.iconFile.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                    if let data = data {
                        let iconImage = UIImage(data: data)!
                        completion(iconImage : iconImage, title: title, description: description)
                    } else {
                        completion(iconImage : iconImage, title: title, description: description)
                    }
                })
                
            } else {
                let title = "Couldn't load your favorite. :("
                let description = "We're sorry. Make sure you are connected to the internet."
                completion(iconImage: iconImage, title: title, description: description)
            }
        }
    }
}

struct LongestStreak: ProfileItem {
    let iconImage = UIImage(named: "LongestStreakIcon")!
    let errorTitle = "Oh no!"
    let errorDescription = "Something went wrong. Check your connection."
    
    func getItemInformation(completion: (iconImage: UIImage, title: String, description: String) -> (Void)) {
        if let user = PFUser.currentUser() {
            user.fetchInBackgroundWithBlock({ (user: PFObject?, _) -> Void in
                if let user = user {
                    let longestStreak = user[Constants.Parameters.longestStreak] as? Int ?? 0
                    let title = "\(longestStreak) Days"
                    let description = "Your longest streak lasted for \(longestStreak) days"
                    completion(iconImage: self.iconImage, title: title, description: description)
                } else {
                    completion(iconImage: self.iconImage, title: self.errorTitle, description: self.errorDescription)
                }
            })
        } else {
            completion(iconImage: iconImage, title: errorTitle, description: errorDescription)
        }
    }
}