////
////  ZSSJournalParentViewController.swift
////  Swole
////
////  Created by Zachary Shakked on 4/29/15.
////  Copyright (c) 2015 Zachary Shakked. All rights reserved.
////

import UIKit

@objc class ZSSJournalParentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController : UIPageViewController!
    var activityEvent : ActivityEvent?
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()

        ActivityManager.sharedManager.activityEvent(NSDate(), completion: { (activityEvent) -> (Void) in
            self.activityEvent = activityEvent  
        })
    }

    func configurePageViewController() -> Void {
        self.pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController.dataSource = self
        self.pageController.view.frame = self.view.bounds
        
        let ftvc = FeedTableViewController(style: .Grouped)
        ftvc.date = NSDate()
        let initialViewController = ftvc
        self.pageController.setViewControllers([initialViewController], direction: .Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageController)

        self.view.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
           pageController.delegate = self
        
        
        navigationController?.configureNavBar(GlobalStyles.greenColor(), textColor: UIColor.whiteColor())
        navigationItem.rightBarButtonItem = UIBarButtonItem.addBarButton(self, tintColor: UIColor.whiteColor(), selector: "addActivities")
        navigationItem.title = NSDate().string()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var hvc = viewController as! FeedTableViewController
        var date = hvc.date
        date = date!.dateByAddingTimeInterval(-60*24*60)
        let ftvc = FeedTableViewController(style: .Grouped)
        ftvc.date = date
        return ftvc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var hvc = viewController as! FeedTableViewController
        var date = hvc.date
        date = date!.dateByAddingTimeInterval(60*24*60)
        let ftvc = FeedTableViewController(style: .Grouped)
        ftvc.date = date
        return ftvc
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        if let hvc = pendingViewControllers[0] as? FeedTableViewController, date = hvc.date {
            let calendar = NSCalendar.currentCalendar()
            navigationItem.rightBarButtonItem?.enabled = calendar.isDateInToday(date)
            navigationItem.title = date.string()
        }
    }
    
    func addActivities() {
        if let activityEvent = activityEvent {
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
}
