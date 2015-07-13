//
//  UIBarButtonItem+Helpers.swift
//  Talking Pick Up Line Generator
//
//  Created by pixable on 6/13/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func settingsBarButton(target: UIViewController, tintColor: UIColor, selector: Selector) -> UIBarButtonItem {
        let settingsButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
        settingsButton.bounds = CGRectMake(0, 0, 25, 25)
        settingsButton.setBackgroundImage(UIImage(named: "SettingsIcon")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        settingsButton.tintColor = tintColor
        settingsButton.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        let settingsBarButton = UIBarButtonItem(customView: settingsButton)
        return settingsBarButton
    }
    
    class func cancelBarButton(target: UIViewController, tintColor: UIColor, selector: Selector) -> UIBarButtonItem {
        let cancelButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
        cancelButton.bounds = CGRectMake(0, 0, 25, 25)
        let cancelImage = UIImage(named: "CancelIcon")!.imageWithRenderingMode(.AlwaysTemplate)
        cancelButton.tintColor = tintColor
        cancelButton.setBackgroundImage(cancelImage, forState: .Normal)
        cancelButton.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        return cancelBarButton
    }
    
    class func doneBarButton(target: UIViewController, tintColor: UIColor, selector: Selector) -> UIBarButtonItem {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: target, action: selector)
        doneBarButton.tintColor = tintColor
        return doneBarButton
    }
    
    class func addBarButton(target: UIViewController, tintColor: UIColor, selector: Selector) -> UIBarButtonItem {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: target, action: selector)
        addBarButton.tintColor = tintColor
        return addBarButton
    }
}
