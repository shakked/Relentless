//
//  SignUpViewController.swift
//  Relentless
//
//  Created by pixable on 7/10/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingAnimator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "SignUpViewController", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func signUpButtonPressed(sender: AnyObject) {
        loadingAnimator.startAnimating()
        LoginManager.sharedManager.logInWithFacebook { (succeeded) -> (Void) in
            if !succeeded {
                let alert = AMSmoothAlertView(dropAlertWithTitle: "Something went wrong!", andText: "We couldn't log you in.", andCancelButton: false, forAlertType: AlertType.Failure)
                alert.show()
            }
        }
        
    }
    
    func onProfileUpdated(notification: NSNotification) {
        LoginManager.sharedManager.loginAndLinkFBAccessTokenWithParse({ (succeeded) -> (Void) in
            if succeeded {
                LoginManager.sharedManager.configureUser({ (succeeded) -> (Void) in
                    let ftvc = FeedTableViewController(style: .Grouped)
                    ftvc.date = NSDate()
                    self.presentViewController(UINavigationController(rootViewController: ftvc), animated: true, completion: nil)
                })
            } else {
                let alert = AMSmoothAlertView(dropAlertWithTitle: "Something went wrong!", andText: "We couldn't log you in.", andCancelButton: false, forAlertType: AlertType.Failure)
                alert.show()
            }
        })
    }
}