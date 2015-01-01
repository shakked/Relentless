//
//  FeedTableViewController.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    var activityEvent : ActivityEvent = ActivityEvent.empty() {
        didSet {
            navigationItem.title = activityEvent.date.string()
            tableView.reloadData()
        }
    }
    var date : NSDate? {
        didSet {
            loadData()
        }
    }
    var streakView : StreakView?
    var streak : Int = 0 {
        didSet {
            streakView?.streakLabel.text = "\(streak)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Loading Data
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
    }
    
    func loadData() {
        ActivityManager.sharedManager.activityEvent(date ?? NSDate(), completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
        ActivityManager.sharedManager.calculateAndSaveStreak({ (streak, succeeded) -> Void in
            self.streak = streak
            self.tableView.reloadData()
        })
        
        //
    }
    
    //MARK:- TableView DataSource and Configuration/NavBar
    
    func configureTableView() {
        tableView.registerNib(UINib(nibName: Constants.Cells.ActivityCell, bundle: nil), forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ActivityCell
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
        
        cell.moreButtonBlock = {
            let alertController = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
                activity.object.deleteInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
                    if succeeded {
                        self.activityEvent.activities.removeObject(activity)
                        self.activityEvent.object?.removeObject(activity.object, forKey: Constants.Parameters.activities)
                        self.activityEvent.object?.saveEventually(nil)
                        self.tableView.beginUpdates()
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        self.tableView.endUpdates()
                    } else {
                        let alert = AMSmoothAlertView(dropAlertWithTitle: "Something went wrong!", andText: "We couldn't delete the activity.", andCancelButton: false, forAlertType: AlertType.Failure)
                        alert.show()
                    }
                })
            }
            alertController.addAction(deleteAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let calendar = NSCalendar.currentCalendar()
        streakView = NSBundle.mainBundle().loadNibNamed(Constants.Views.StreakView, owner: self, options: nil)[0] as? StreakView
        streakView?.streakLabel.text = "\(streak)"
        return streakView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    
    //MARK:- Navigation
    
}
