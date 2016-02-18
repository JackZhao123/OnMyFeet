//
//  DataViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-17.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dailyActivitySummary(sender: AnyObject) {
        let date = "2016-02-16"

        let request = FitbitAPI()
        let url = NSURL(string: "https://api.fitbit.com/1/user/-/activities/date/\(date).json")
        
        if let url = url {
            request.requestToFitbit("GET", url: url)
        }
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
