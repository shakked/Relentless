//
//  HomeViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    weak var journalParentViewController : ZSSJournalParentViewController!
    @IBOutlet weak var didYouWorkOutLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var restedButton: UIButton!

    var activityEvent: ActivityEvent
    
    required init(date: NSDate) {
        activityEvent = ActivityStore.sharedStore().activityEventForDate(date)
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
        activityEvent = ActivityStore.sharedStore().activityEventForDate(date)
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
            activityEvent.hasEnergyConsumers() ? selectYesButton() : selectRestedButton()
        } else {
            unselectYesButton()
            unselectRestedButton()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureYesButtonIfNeed()
    }

    @IBAction func goLeftButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func goRightButtonPressed(sender: AnyObject) {

    }
    
    @IBAction func yesButtonPressed(sender: AnyObject) {
        showWhatDidYouDoTable()
    }
    
    @IBAction func iRestedButtonPressed(sender: AnyObject) {
        if activityEvent.has("Rest") {
            unselectRestedButton()
        } else {
            selectRestedButton()
        }
    }
    
    func showWhatDidYouDoTable() {
        let wdydtvc = WhatDidYouDoTableViewController(activityEvent: activityEvent)
        let nav = UINavigationController(rootViewController: wdydtvc)
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func selectRestedButton() {
        if !activityEvent.has("Rest") {
            activityEvent.addRest()
        }
        configureYesButtonIfNeed()
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = GlobalStyles.blueColor()
            self.restedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        })
    }
    
    func unselectRestedButton() {
        activityEvent.removeRest()
        UIView.animateWithDuration(0.50, animations: {
            self.restedButton.backgroundColor = UIColor.clearColor()
            self.restedButton.setTitleColor(GlobalStyles.blueColor(), forState: .Normal)
        })
    }
    
    func configureYesButtonIfNeed() {
        if activityEvent.hasEnergyConsumers() {
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
