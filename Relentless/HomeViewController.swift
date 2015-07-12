//
//  HomeViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
//    weak var journalParentViewController : ZSSJournalParentViewController!
    @IBOutlet weak var didYouWorkOutLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var restedButton: UIButton!

    var activityEvent: ActivityEvent = ActivityEvent.empty() {
        didSet {
            configureButtons()
        }
    }
    
    required init(date: NSDate) {
        super.init(nibName: "HomeViewController", bundle: NSBundle.mainBundle())
        ActivityManager.sharedManager.activityEvent(date, completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureButtons()
    }
    
    func changeDate(date: NSDate) {
        ActivityManager.sharedManager.activityEvent(date, completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent
        })
    }
    
    func configureViews() {
        navigationController?.configureNavBar(UIColor.whiteColor(), textColor: GlobalStyles.greenColor())
    }
    
    func configureButtons() {
        if activityEvent.hasEnergyConsumer() {
            selectYesButton()
            unselectRestedButton()
        } else if activityEvent.hasActivityTypeWithName(Constants.ActivityType.rest) {
            unselectYesButton()
            selectRestedButton()
        } else {
            unselectYesButton()
            unselectRestedButton()
        }
    }

    @IBAction func goLeftButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func goRightButtonPressed(sender: AnyObject) {

    }
    
    @IBAction func yesButtonPressed(sender: AnyObject) {
        showWhatDidYouDoTable()
    }
    
    @IBAction func iRestedButtonPressed(sender: AnyObject) {

    }
    
    func showWhatDidYouDoTable() {
        let wdydtvc = WhatDidYouDoTableViewController(activityEvent: activityEvent)
        let nav = UINavigationController(rootViewController: wdydtvc)
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func selectRestedButton() {
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = GlobalStyles.blueColor()
            self.restedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        })
    }
    
    func unselectRestedButton() {
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = UIColor.clearColor()
            self.restedButton.setTitleColor(GlobalStyles.blueColor(), forState: .Normal)
        })
    }
    
    func configureYesButtonIfNeed() {
//        if activityEvent.hasEnergyConsumers() {
//            selectYesButton()
//            unselectRestedButton()
//        } else {
//            unselectYesButton()
//        }
    }
    
    func selectYesButton() {
        UIView.animateWithDuration(0.50, animations: {
            self.yesButton.backgroundColor = GlobalStyles.greenColor()
            self.yesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        })
    }
    
    func unselectYesButton() {
        UIView.animateWithDuration(0.50, animations: {
            self.yesButton.backgroundColor = UIColor.clearColor()
            self.yesButton.setTitleColor(GlobalStyles.greenColor(), forState: .Normal)
        })
    }
}
