//
//  ActivityTypeTableViewController.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityTypeTableViewController: UITableViewController, DoneCancelViewDelegate {
        
    let REUSE_IDENTIFIER = "cell"
    var activityEvent : ActivityEvent
    var activityTypes : [ActivityType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var activityTypesToCreateActivitiesFor : [ActivityType] = []
    
    required init(activityEvent: ActivityEvent) {
        self.activityEvent = activityEvent
        super.init(nibName: nil, bundle: nil)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.cancelBarButton(self, tintColor: UIColor.whiteColor(), selector: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem.doneBarButton(self, tintColor: UIColor.whiteColor(), selector: "done")
        navigationController?.configureNavBar(UIColor.clearColor(), textColor: UIColor.whiteColor())
        title = "What did you do today?"
        configureTableView()

        ActivityManager.sharedManager.activityTypesThatConsumeEnergy { (activityTypes, succeeded) -> Void in
            self.activityTypes = activityTypes
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

    }
    
    override func viewDidAppear(animated: Bool) {
        addDoneCancelView()
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: Constants.Cells.ActivityTypeCell, bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return activityTypes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityType = activityTypes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER) as! ActivityTypeCell
        cell.selectionStyle = .None
        cell.nameLabel.text = activityType.name
        cell.descriptionLabel.text = activityType.explanation
        cell.backgroundColor = UIColor.clearColor()
        cell.checkmarkImageView.tintColor = GlobalStyles.greenColor()
        cell.checkmarkImageView.hidden = contains(activityTypesToCreateActivitiesFor, activityType) ? false : true
        activityType.iconFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                cell.iconImageView.image = UIImage(data: data!)
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityType = activityTypes[indexPath.row]
        
        if contains(activityTypesToCreateActivitiesFor, activityType) {
            activityTypesToCreateActivitiesFor.removeObject(activityType)
        } else {
            activityTypesToCreateActivitiesFor.append(activityType)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func addDoneCancelView() {
        let doneCancelView = NSBundle.mainBundle().loadNibNamed(Constants.Views.DoneCancelView, owner: self, options: nil)[0] as! DoneCancelView
        doneCancelView.delegate = self
        let frame = UIApplication.sharedApplication().keyWindow!.bounds
        doneCancelView.frame = CGRectMake(0, frame.size.height - 50, frame.size.width, 50)
        doneCancelView.layoutIfNeeded()
        view.addSubview(doneCancelView)
        UIApplication.sharedApplication().keyWindow?.addSubview(doneCancelView)
    }

    func doneButtonPressed() {
        ActivityType.createActivities(activityTypesToCreateActivitiesFor, activityEvent: activityEvent, completion: { (succeeded, activities) -> Void in
            if succeeded {
                self.activityEvent.addActivities(activities)
            } else {
                println("failed to add activites")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    
    func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: {
            println("DONE")
        })
    }
}

