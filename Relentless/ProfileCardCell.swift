//
//  ProfileCardCell.swift
//  Relentless
//
//  Created by pixable on 7/15/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ProfileCardCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
