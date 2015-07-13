//
//  WhatDidYouDoTableViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class WhatDidYouDoTableViewController: UITableViewController {
    var activityEvent : ActivityEvent
    var activityTypes : [ActivityType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let REUSE_IDENTIFIER = "cell"
    
    var activityTypesToCreate : [ActivityType] = []
    
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
        
        ActivityManager.sharedManager.activityTypesThatConsumeEnergy { (activityTypes, succeeded) -> Void in
            self.activityTypes = activityTypes
        }
    }
    
    func configureTableView() {
        tableView.registerNib(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityTypes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityType = activityTypes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER) as! ActivityCell
        cell.activityNameLabel.text = activityType.name
        contains(activityTypesToCreate, activityType) ? configureSelectedCell(cell) : configureUnselectedCell(cell)
        
        if cell.iconImageView.image == nil {
            activityType.iconFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    cell.iconImageView.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityType = activityTypes[indexPath.row]
        
        if contains(activityTypesToCreate, activityType) {
            activityTypesToCreate.removeObject(activityType)
        } else {
            activityTypesToCreate.append(activityType)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
//        ActivityType.createActivities(activityTypesToCreate, completion: { (succeeded, activities) -> Void in
//            if succeeded {
//                self.activityEvent.addActivities(activities)
//            } else {
//                println("failed to add activites")
//            }
//            self.dismissViewControllerAnimated(true, completion: nil)
//        })
    }
}
