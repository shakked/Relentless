//
//  File.swift
//  Talking Joke Generator
//
//  Created by pixable on 6/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

extension UIImage {
    class func screenshot(view: UIView) -> UIImage {
        let window = UIApplication.sharedApplication().windows.first as! UIWindow
        let layer = view.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
}
