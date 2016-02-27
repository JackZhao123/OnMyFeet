//
//  ProgressViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    let fitbitAPI = FitbitAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Progress"
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backBtn

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func getSteps(sender: AnyObject) {

    }
    
    @IBAction func getDistances(sender: AnyObject) {
    }
    
    @IBAction func getIntensity(sender: AnyObject) {
        
    }
    
    @IBAction func getSleep(sender: AnyObject) {
        
    }
    
    @IBAction func setAlarm(sender: AnyObject) {

    }
    
    @IBAction func getSedentaryMinutes(sender: AnyObject) {
    }
    
}
