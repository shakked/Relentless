//
//  WhatDidYouDoTableViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class WhatDidYouDoTableViewController: UITableViewController {
    
    let activities = ActivityManager.allActivities()
    var activityEvent : ActivityEvent
    let REUSE_IDENTIFIER = "cell"
    
    required init(activityEvent: ActivityEvent) {
        self.activityEvent = activityEvent
        super.init(nibName: nil, bundle: nil)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.cancelBarButton(self, tintColor: GlobalStyles.grayColor(), selector: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem.doneBarButton(self, tintColor: GlobalStyles.greenColor(), selector: "done")
        navigationController?.configureNavBar(UIColor.whiteColor(), textColor: GlobalStyles.greenColor())
        title = "What did you do today?"
        configureTableView()
    }
    
    func configureTableView() {
        tableView.registerNib(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER) as! ActivityCell
        cell.activityNameLabel.text = activity.name
        
        activityEvent.has(activity) ? configureSelectedCell(cell) : configureUnselectedCell(cell)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activity = activities[indexPath.row]
        
        if activityEvent.has(activity) {
            activityEvent.remove(activity)
        } else {
            activityEvent.add(activity)
        }

        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func configureSelectedCell(cell: ActivityCell) {
        
        cell.activityNameLabel.textColor = GlobalStyles.greenColor()
        cell.accessoryType = .Checkmark
    }
    
    func configureUnselectedCell(cell: ActivityCell) {
        
        cell.activityNameLabel.textColor = GlobalStyles.grayColor()
        cell.accessoryType = .None
    }
    
    func cancel() {
        activityEvent.removeAllEnergyConsumers()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UITableViewCell {
    func clean() {
        accessoryType = .None
    }
}
