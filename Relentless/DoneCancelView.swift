//
//  DoneCancelView.swift
//  Relentless
//
//  Created by pixable on 7/12/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class DoneCancelView: UIView {

    var delegate : DoneCancelViewDelegate?
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        delegate?.doneButtonPressed()
        self.removeFromSuperview()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        delegate?.cancelButtonPressed()
        self.removeFromSuperview()
    }
}

protocol DoneCancelViewDelegate {
    func doneButtonPressed()
    func cancelButtonPressed()
}
