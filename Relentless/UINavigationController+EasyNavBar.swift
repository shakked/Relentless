//
//  UINavigationController+EasyNavBar.swift
//  Talking Pick Up Line Generator
//
//  Created by pixable on 6/13/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

extension UINavigationController {
    func configureNavBar(barTintColor: UIColor, textColor: UIColor, font: UIFont = UIFont(name: "HelveticaNeue-Light", size: 18.0)!) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = textColor
        navigationBar.translucent = false
        navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : textColor]
    }
}
