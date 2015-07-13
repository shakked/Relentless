//
//  FeedTableViewController.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    let REUSE_IDENTIFIER = "cell"
    var removeBlurBlock : ((Void) -> (Void))?
    var activityEvent : ActivityEvent = ActivityEvent.empty() {
        didSet {
            title = activityEvent.date.string()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadData()
    }
    
    func loadData() {
        ActivityManager.sharedManager.activityEvent(NSDate(), completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent
            self.refreshControl?.endRefreshing()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let removeBlurBlock = removeBlurBlock {
            removeBlurBlock()
        }
    }
    
    func configureTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.addBarButton(self, tintColor: UIColor.whiteColor(), selector: "addActivities")
        navigationController?.configureNavBar(GlobalStyles.greenColor(), textColor: UIColor.whiteColor())
        tableView.registerNib(UINib(nibName: Constants.Cells.ActivityCell, bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
        tableView.separatorStyle = .None
        tableView.backgroundColor = GlobalStyles.lightGrayColor()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityEvent.activities.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 106
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activity = activityEvent.activities[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as! ActivityCell
        cell.activityNameLabel.text = activity.type.name
        cell.timeLabel.text = NSDate().timeAgoSinceDate(activity.date, numericDates: true)
        cell.selectionStyle = .None
        activity.type.iconFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
            if let data = data {
                cell.iconImageView.image = UIImage(data: data)
            } else {
                //PUT A PLACEHOLDER IMAGE
            }
        })
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return NSBundle.mainBundle().loadNibNamed(Constants.Views.StreakView, owner: self, options: nil)[0] as! StreakView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    
    
    func addActivities() {
        let attvc = ActivityTypeTableViewController(activityEvent: activityEvent)
        attvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(attvc, animated: true, completion: nil)
    }
}