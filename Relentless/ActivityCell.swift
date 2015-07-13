
//
//  ActivityCell.swift
//  Relentless
//
//  Created by pixable on 6/16/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    var activity : Activity!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    var editButtonBlock : ((Void) -> (Void))!
    var shareButtonBlock : ((Void) -> (Void))!
    var moreButtonBlock : ((Void) -> (Void))!
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        editButtonBlock()
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        shareButtonBlock()
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        moreButtonBlock()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
}

