//
//  BackendOperation.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import Alamofire

class BackendOperation {
    
    static func getStepsDataWith(dateTime: String) {
        
    }
    
    static func postData() {
        let parameters = [
            "stepsData": ["2016-03-02":"2000"]
        ]
        
        Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/dataUpload", parameters: parameters, encoding: .JSON).responseString(completionHandler: {response in
            print("Response, \(response.result.value)")
        })
    }
    
    static func sendStepsData() {
        if let summary = ClientDataManager.sharedInstance().fetchAllSummaryData() {
            var stepsData = [[String:Int]]()
            var distanceData = [[String:Int]]()
            let fitbitID = NSUserDefaults.standardUserDefaults().valueForKey("CurrentDeviceID")
            
            for s in summary {
                let dateTime = s.dateTime!
                let stepsValue = s.steps!.integerValue
                let distanceValue = s.distance!.integerValue
                
                distanceData.append([dateTime: distanceValue])
                stepsData.append([dateTime: stepsValue])
            }
            if stepsData.count > 0 {
                let parameters = ["fitbit_ID": fitbitID!,
                    "stepData":stepsData,
                    "distanceData":distanceData]
                print(parameters)
                
                Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/postData/fitbit", parameters: parameters, encoding: .JSON).responseString(completionHandler: {response in
                    print("Response, \(response.result.value)")
                })
            }
        }
    }
    
}