//
//  HomeViewController.swift
//  Relentless
//
//  Created by pixable on 6/14/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var restedButton: UIButton!
    
    init() {
        super.init(nibName: "HomeViewController", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.translucent = false
        yesButton.layer.borderColor = yesButton.titleLabel?.textColor.CGColor
        restedButton.layer.borderColor = restedButton.titleLabel?.textColor.CGColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
