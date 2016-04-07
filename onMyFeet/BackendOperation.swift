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
    
    static func post(parameters:[String:AnyObject], dataType:String) {
        var data:[String:AnyObject] = [dataType:parameters]
        data["fb_id"] = "\(Constants.Fitbit.id)"
        
        Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/postData/fitbit", parameters: data, encoding: .JSON).responseString(completionHandler: {response in
                        print("Response, \(response.result.value)")
            })
    }
    
    static func sendDistanceData(start:String, end:String) {
        var startDate = start
        let endDate = end
        var interval = DateStruct.compare(startDate, with: endDate)
        
        var data = [String:AnyObject]()
        var distanceData = [String:Float]()
        
        while interval <= 0 {
            if let summary = ClientDataManager.sharedInstance().fetchSummaryWith(startDate) {
                let dateTime = summary.dateTime!
                let distanceValue = summary.distance?.floatValue
                
                distanceData[dateTime] = distanceValue! * 1000
            }
            
            startDate = DateStruct.dateValueChangeFrom(startDate, by: 1)
            interval = DateStruct.compare(startDate, with: endDate)
        }
        
        data["distanceData"] = distanceData
        post(distanceData, dataType: "distanceData")
    }
    
    static func sendStepData(start:String, end:String) {
        var startDate = start
        let endDate = end
        var interval = DateStruct.compare(startDate, with: endDate)
        
        var data = [String:AnyObject]()
        var stepsData = [String:Int]()
        
        while interval <= 0 {
            if let summary = ClientDataManager.sharedInstance().fetchSummaryWith(startDate) {
                let dateTime = summary.dateTime!
                let stepsValue = summary.steps?.integerValue
                
                stepsData[dateTime] = stepsValue
            }
            
            startDate = DateStruct.dateValueChangeFrom(startDate, by: 1)
            interval = DateStruct.compare(startDate, with: endDate)
        }
        
        data["stepData"] = stepsData
        post(stepsData, dataType: "stepData")
    }
    
}