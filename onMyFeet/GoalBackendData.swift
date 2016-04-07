//
//  GoalBackendData.swift
//  OnMyFeet
//
//  Created by apple on 16/4/2.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import Foundation
import Alamofire

class GoalBackendData {
    
    func postActivityLatestData() {
        
        if let activities = GoalDataManager().fetchActivities() {
            
            var parameters = [String:AnyObject]()
            var activityData = [String:Int]()
            
            for act in activities {
                let theName = act.name
                let theStatus = Int(act.status * 1000)
                
                activityData[theName] = theStatus
            }
            
            parameters = ["fb_id": "\(Constants.Fitbit.id)", "goals": activityData]
            
            Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/postData/goals", parameters: parameters, encoding: .JSON).responseString(completionHandler: {response in
                print("Response, \(response.result.value)")
            })
        }
    }
}
