//
//  UINavigationController+EasyNavBar.swift
//  Talking Pick Up Line Generator
//
//  Created by pixable on 6/13/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

extension UINavigationController {
    func configureNavBar(barTintColor: UIColor, textColor: UIColor, font: UIFont = UIFont(name: "Avenir", size: 18.0)!, barStyle: UIBarStyle = .Black) {
        navigationBar.barTintColor = barTintColor
        navigationBar.barStyle = barStyle
        navigationBar.tintColor = textColor
        navigationBar.translucent = false
        navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : textColor]
    }
}
