//
//  LogInViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import SafariServices

class LogInViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInBtn.layer.cornerRadius = 8.0;
        logInBtn.clipsToBounds = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func didBecomeActive() {
        if NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func logIn(sender: AnyObject) {
        //print("Logging in");
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=227GMP&redirect_uri=onmyfeet://&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&prompt=login")!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
