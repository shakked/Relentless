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

        // Do any additional setup after loading the view.
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
            if succeeded {
                LoginManager.sharedManager.loginAndLinkFBAccessTokenWithParse({ (succeeded) -> (Void) in
                    if succeeded {
                        LoginManager.sharedManager.configureUser({ (succeeded) -> (Void) in
                            println("Succeeded:\(succeeded)")
                        })
                        
                    } else {
                        println("Could not link Parse to Facebook")
                    }
                })
            } else {
                println("Could not log in the user through facebook.")
            }
        }
        
    }
    
    
}