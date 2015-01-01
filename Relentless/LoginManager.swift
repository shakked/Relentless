//
//  LoginManager.swift
//  Relentless
//
//  Created by pixable on 7/10/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    
    class var sharedManager: LoginManager {
        struct Static {
            static let instance: LoginManager = LoginManager()
        }
        return Static.instance
    }
    
    func logInWithFacebook(completion: (Bool) -> (Void)) {
        if FBSDKAccessToken.currentAccessToken() == nil {
            //only friends that have the application -> facebook invites
            FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: { (result, error) -> Void in
                if error == nil && !result.isCancelled {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        } else {
            completion(true)
        }
    }
    
    func loginAndLinkFBAccessTokenWithParse(completion: (Bool) -> (Void)) {
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        let facebookId = FBSDKProfile.currentProfile().userID
        let expirationDate = FBSDKAccessToken.currentAccessToken().expirationDate
        PFFacebookUtils.logInWithFacebookId(facebookId, accessToken: accessToken, expirationDate: expirationDate) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func configureUser(completion: (Bool) -> (Void)) {
        if let user = PFUser.currentUser() {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    let result = (result as! [String : AnyObject])
                    let email = result["email"] as! String
                    let firstName = FBSDKProfile.currentProfile().firstName
                    let lastName = FBSDKProfile.currentProfile().lastName
                    let name = FBSDKProfile.currentProfile().name
                    
                    let user = PFUser.currentUser()!
                    user.setValue(email, forKey: "email")
                    user.setValue(firstName, forKey: "firstName")
                    user.setValue(lastName, forKey: "lastName")
                    user.setValue(name, forKey: "name")
                    user.saveInBackgroundWithBlock({ (succeeded, _) -> Void in
                        completion(succeeded)
                    })
                } else {
                    completion(false)
                }
            })
        } else {
           completion(false)
        }
    }
    
    func configureFacebookLinkedUser(completion:((succeeded: Bool, error: NSError?) -> Void)) {
        let fbRequest = FBRequest.requestForMe()
        fbRequest.startWithCompletionHandler { (_, result, error) -> Void in
            let userInfo : Dictionary<String, AnyObject> = result as! Dictionary
            PFUser.currentUser()!.setValue(userInfo["id"], forKey: "id")
            PFUser.currentUser()!.setValue(userInfo["first_name"], forKey: "firstName")
            PFUser.currentUser()!.setValue(userInfo["last_name"], forKey: "lastName")
            PFUser.currentUser()!.setValue(userInfo["email"], forKey: "email")
            PFUser.currentUser()!.setValue(NSNumber(bool: true), forKey: "didFillOutUserInfoForm")
            PFUser.currentUser()!.setValue("facebook", forKey: "authType")
            
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                completion(succeeded: succeeded, error: error)
            })
        }
    }
}
