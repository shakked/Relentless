//
//  ProfileTableViewController.swift
//  Relentless
//
//  Created by pixable on 7/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ProfileTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var headerView : HeaderView?
    var parallaxHeaderView : ParallaxHeaderView!
    var tableView : UITableView!
    var imageView : UIImageView!
    let profileItems : [ProfileItem] = ProfileModel.sharedModel.profileItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table View / Data Source
    func configureTableView() {
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        imageView = UIImageView(image: UIImage(named: "nyc-monthly-parking.jpg")!)
        imageView.frame = CGRectMake(0, 0, self.view.frame.width, 200)
        self.view.addSubview(imageView)
        self.view.addSubview(tableView)
        
        tableView.registerNib(UINib(nibName: Constants.Cells.ProfileCardCell, bundle: nil), forCellReuseIdentifier: "cell")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let profileItem = profileItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileCardCell
        cell.selectionStyle = .None
        profileItem.getItemInformation { (iconImage, title, description) -> (Void) in
            cell.iconImageView.image = iconImage
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView = NSBundle.mainBundle().loadNibNamed(Constants.Views.HeaderView, owner: self, options: nil)[0] as? HeaderView
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < 0 {
            let scaleY = 1 + (-0.01 * contentOffsetY)
            imageView.transform = CGAffineTransformMakeScale(scaleY, scaleY)
        }
    }
}
