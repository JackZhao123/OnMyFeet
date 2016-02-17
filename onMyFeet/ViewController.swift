//
//  ViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-15.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import SafariServices

var access_token:String?

class ViewController: UIViewController {
//    MARK: Outlet
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var tokenTextView: UITextView!
    
//    MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let access_token = access_token {
            self.tokenTextView.text = access_token
        } else {
            self.tokenTextView.text = "No Token Aviable"
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        initSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didBecomeActive() {
        self.tokenTextView.text = access_token
    }

    func initSubView() {
        self.logInBtn.layer.cornerRadius = 5.0
        self.logInBtn.clipsToBounds = true
    }

    @IBAction func logIn(sender: AnyObject) {
        //print("Logging in");
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=227GMP&redirect_uri=onmyfeet://&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800")!)
    }
}

