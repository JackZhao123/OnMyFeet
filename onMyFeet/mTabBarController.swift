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
        addViewcontrollers()
        
    }
    
    func addViewcontrollers() {
        let dailyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DailyProgressController") as! DailyProgressViewController
        let dailyTabBarItem: UITabBarItem = UITabBarItem(title: "Daily Progress", image: UIImage(named: "Daily"), tag: 0)
        dailyController.tabBarItem = dailyTabBarItem
        
        let weeklyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WeeklyProgressController") as! WeeklyProgressViewController
        let weeklyTabBarItem: UITabBarItem = UITabBarItem(title: "Weekly Progress", image: UIImage(named: "Weekly"), tag: 1)
        weeklyController.tabBarItem = weeklyTabBarItem
        
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
