//
//  ZSSJournalParentViewController.swift
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

@objc class ZSSJournalParentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        configureViews()
    }

    func configurePageViewController() -> Void {
        self.pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController.dataSource = self
        self.pageController.view.frame = self.view.bounds
        
        let initialViewController = HomeViewController(date: NSDate())
        self.pageController.setViewControllers([initialViewController], direction: .Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageController)

        self.view.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
           pageController.delegate = self
    }
    
    func configureViews() -> Void {
        configureNavBar()
    }
    
    func goLeftButtonPressed() {
        println("Go left!!!!")
    }
    
    func configureNavBar() -> Void {
        navigationController?.configureNavBar(UIColor.whiteColor(), textColor: GlobalStyles.greenColor())
        title = NSDate().string()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var hvc = viewController as! HomeViewController
        var date = hvc.activityEvent.date
        date = date.dateByAddingTimeInterval(-60*24*60)
        return HomeViewController(date: date)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var hvc = viewController as! HomeViewController
        var date = hvc.activityEvent.date
        date = date.dateByAddingTimeInterval(60*24*60)
        return HomeViewController(date: date)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        if let hvc = pendingViewControllers[0] as? HomeViewController {
            let date = hvc.activityEvent.date
            navigationItem.title = date.string()
        }
    }
}
