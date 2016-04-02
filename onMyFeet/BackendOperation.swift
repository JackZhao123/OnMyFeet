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
    
    static var requestFlag = false
    
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
    
    static func post(parameters:[String:AnyObject], dataType:String) {
        var data:[String:AnyObject] = [dataType:parameters]
        data["fb_id"] = "00000000"
        
        Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/postData/fitbit", parameters: data, encoding: .JSON).responseString(completionHandler: {response in
                        print("Response, \(response.result.value)")
            })
        
    }
    
    static func sendStepAndDistanceData(start:String, end:String) {
        var startDate = start
        let endDate = end
        var interval = DateStruct.compare(startDate, with: endDate)
        
        var data = [String:AnyObject]()
        var stepsData = [String:Int]()
        var distanceData = [String:Float]()
        
        while interval <= 0 {
            if let summary = ClientDataManager.sharedInstance().fetchSummaryWith(startDate) {
                let dateTime = summary.dateTime!
                let stepsValue = summary.steps?.integerValue
                let distanceValue = summary.distance?.floatValue
                
                stepsData[dateTime] = stepsValue
                distanceData[dateTime] = distanceValue! * 1000
            }
            
            startDate = DateStruct.dateValueChangeFrom(startDate, by: 1)
            interval = DateStruct.compare(startDate, with: endDate)
        }
        
        data["stepData"] = stepsData
        data["distanceData"] = distanceData
        
//        post(stepsData, dataType: "stepData")
//        post(distanceData, dataType: "distanceData")
        
    }
    
}