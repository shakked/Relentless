//
//  HomeViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var didYouWorkOutLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var restedButton: UIButton!
    var activityEvent : ActivityEvent
    
    required init(date: NSDate) {
        self.activityEvent = ActivityManager.sharedManager.activityEvent(date)
        super.init(nibName: "HomeViewController", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func changeDate(date: NSDate) {
        activityEvent = ActivityManager.sharedManager.activityEvent(date)
        configureViews()
    }
    
    func configureViews() {
        configureNavBar()
        configureButtons()
    }
    
    func configureNavBar() {
        navigationController?.configureNavBar(UIColor.whiteColor(), textColor: GlobalStyles.greenColor())
    }
    
    func configureButtons() {
        yesButton.layer.borderColor = GlobalStyles.greenColor().CGColor
        restedButton.layer.borderColor = GlobalStyles.blueColor().CGColor
        if activityEvent.activities.count > 0 {
            activityEvent.hasEnergyConsumer() ? selectYesButton() : selectRestedButton()
        } else {
            unselectYesButton()
            unselectRestedButton()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureYesButtonIfNeed()
    }

    @IBAction func yesButtonPressed(sender: AnyObject) {
        showWhatDidYouDoTable()
    }
    
    @IBAction func iRestedButtonPressed(sender: AnyObject) {
        activityEvent.has(Rest()) ? unselectRestedButton() : selectRestedButton()
    }
    
    func showWhatDidYouDoTable() {
        let wdydtvc = WhatDidYouDoTableViewController(activityEvent: activityEvent)
        let nav = UINavigationController(rootViewController: wdydtvc)
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func selectRestedButton() {
        activityEvent.removeAll()
        activityEvent.add(Rest())
        configureYesButtonIfNeed()
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = GlobalStyles.blueColor()
            self.restedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        })
    }
    
    func unselectRestedButton() {
        activityEvent.remove(Rest())
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = UIColor.clearColor()
            self.restedButton.setTitleColor(GlobalStyles.blueColor(), forState: .Normal)
        })
    }
    
    func configureYesButtonIfNeed() {
        if activityEvent.hasEnergyConsumer() {
            selectYesButton()
            unselectRestedButton()
        } else {
            unselectYesButton()
        }
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
