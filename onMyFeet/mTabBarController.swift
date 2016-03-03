//
//  mTabBarController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class mTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Progress"
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        addViewcontrollers()
        
    }
    
    func addViewcontrollers() {
        let dailyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DailyProgressController") as! DailyProgressViewController
        dailyController.title = "Daily Progress"
        
        let weeklyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WeeklyProgressController") as! WeeklyProgressViewController
        weeklyController.title = "Weekly Progress"
        
        self.viewControllers = [dailyController, weeklyController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
