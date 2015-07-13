//
//  ActivityTypeTableViewController.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityTypeTableViewController: UITableViewController, DoneCancelViewDelegate {
    
    var activityEvent : ActivityEvent
    var activityTypes : [ActivityType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var activityTypesToCreateActivitiesFor : [ActivityType] = []
    
    //MARK:- Initialization
    
    required init(activityEvent: ActivityEvent) {
        self.activityEvent = activityEvent
        super.init(nibName: nil, bundle: nil)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- View Configuration + Data Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureTableView()
        addDoneCancelView()
    }
    
    func loadData() {
        ActivityManager.sharedManager.activityTypesThatConsumeEnergy { (activityTypes, succeeded) -> Void in
            self.activityTypes = activityTypes
        }
    }

    func configureTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: Constants.Cells.ActivityTypeCell, bundle: nil), forCellReuseIdentifier: "cell")
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
    
    //MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityTypes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityType = activityTypes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ActivityTypeCell
        cell.selectionStyle = .None
        cell.nameLabel.text = activityType.name
        cell.descriptionLabel.text = activityType.explanation
        cell.backgroundColor = UIColor.clearColor()
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
        
        contains(activityTypesToCreateActivitiesFor, activityType) ? activityTypesToCreateActivitiesFor.removeObject(activityType) :             activityTypesToCreateActivitiesFor.append(activityType)
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    //MARK:- Status Bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    //MARK:- DoneCancelViewDelegate

    func doneButtonPressed() {
        ActivityType.createActivities(activityTypesToCreateActivitiesFor, activityEvent: activityEvent, completion: { (succeeded, activities) -> Void in
            succeeded ? self.activityEvent.addActivities(activities) : println("FUCK: failed to add activites")
            self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    
    func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: {
        })
    }
}

