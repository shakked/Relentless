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
            title = activityEvent.date.string()
            tableView.reloadData()
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
        loadData()
        configureTableView()
    }
    
    //MARK:- Loading Data
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData() {
        ActivityManager.sharedManager.activityEvent(NSDate(), completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent
            self.refreshControl?.endRefreshing()
        })
        ActivityManager.sharedManager.calculateStreak({ (streak, succeeded) -> Void in
            self.streak = streak
        })
    }
    
    //MARK:- TableView DataSource and Configuration/NavBar
    
    func configureTableView() {
        navigationController?.configureNavBar(GlobalStyles.greenColor(), textColor: UIColor.whiteColor())
        navigationItem.rightBarButtonItem = UIBarButtonItem.addBarButton(self, tintColor: UIColor.whiteColor(), selector: "addActivities")
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
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        streakView = NSBundle.mainBundle().loadNibNamed(Constants.Views.StreakView, owner: self, options: nil)[0] as? StreakView
        streakView?.streakLabel.text = "\(streak)"
        return streakView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    
    //MARK:- Navigation
    
    func addActivities() {
//        let screenshot = UIImage.screenshot(navigationController!.view)
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let effectView = UIVisualEffectView(effect: blurEffect)
//        effectView.backgroundColor = UIColor.redColor()
//        effectView.frame = UIApplication.sharedApplication().keyWindow!.bounds
        let attvc = ActivityTypeTableViewController(activityEvent: activityEvent)
        let view = UIView(frame: UIApplication.sharedApplication().keyWindow!.bounds)
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [GlobalStyles.greenColor().CGColor, UIColor(rgba: "#99FFDB").CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        attvc.tableView.backgroundView = view
        
        presentViewController(attvc, animated: true, completion: nil)
    }
}
