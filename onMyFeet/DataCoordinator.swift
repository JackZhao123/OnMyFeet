//
//  DataCoordinator.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-27.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

class DataCoordinator: FitbitAPIDelegate {
    //MARK: Properties
    var stepsJson: JSON?
    var distancesJson: JSON?
    var sleepTimeJson: JSON?
    var intradaySleepTimeJson: JSON?
    var intradaySedentaryJson: JSON?
    var sedentaryJson: JSON?
    var lightlyActiveJson: JSON?
    var fairlyActiveJson: JSON?
    var veryActiveJson: JSON?
    
    // Flag
    var gettingDistance = true
    var sleepTimeFinish = true
    var gettingSteps = true
    var gettingSedentary = true
    var gettingLightlyActive = true
    var gettingFairlyActive = true
    var gettingVeryActive = true
    var gettingIntradaySleep = true
    var gettingIntradaySedentary = true
    
    
    static var sharedInstance: DataCoordinator = {
        struct Static {
            static let instance = DataCoordinator()
        }
        return Static.instance
    }()
    
    var dataManager: ClientDataManager = {
        return ClientDataManager.sharedInstance()
    }()
    
    var fitbitAPI = FitbitAPI()
    
    
    //MARK: Method
    func syncData() {
        let userName = NSUserDefaults.standardUserDefaults().objectForKey("CurrentUser") as? String
        fitbitAPI.refreshAccessToken()
        fitbitAPI.delegate = self
        
        if let userName = userName {
            let userData: Person
            if dataManager.fetchPersonWith(userName) == nil {
                dataManager.createPersonData(userName)
            }

            userData = dataManager.fetchPersonWith(userName)!
            updateData(userData)
        }
    }
    
    func updateData(userData: Person) {
        
        if (userData.summary?.count == 0) {
            print("Load All Data")
            let dateTime = "2016-02-01"
            self.fitbitAPI.getDaily(typeOfData: "steps", startDate: dateTime, toEndDate: "today")
            self.fitbitAPI.getDaily(typeOfData: "distance", startDate: dateTime, toEndDate: "today")
            self.fitbitAPI.getDaily(typeOfData: "minutesLightlyActive", startDate: dateTime, toEndDate: "today")
            self.fitbitAPI.getDaily(typeOfData: "minutesFairlyActive", startDate: dateTime, toEndDate: "today")
            self.fitbitAPI.getDaily(typeOfData: "minutesVeryActive", startDate: dateTime, toEndDate: "today")
            self.fitbitAPI.getDaily(typeOfData: "minutesSedentary", startDate: dateTime, toEndDate: "today")

        } else {
            print("Update Needed Data")
            gettingSteps = false
            gettingDistance = false
            gettingSedentary = false
            gettingLightlyActive = false
            gettingFairlyActive = false
            gettingVeryActive = false
            sleepTimeFinish = false
        }
        
        while(gettingDataFlag()){}
        
        if let stepsJson = stepsJson {
            if (stepsJson["activities-steps"].count > 0)  {
                
                for index in 0...stepsJson["activities-steps"].count - 1 {
                    
                    let dateTime = stepsJson["activities-steps"][index]["dateTime"].stringValue
                    let stepsValue = stepsJson["activities-steps"][index]["value"].numberValue
                    let distanceValue = distancesJson!["activities-distance"][index]["value"].numberValue
                    let minutesLightlyActiveValue = lightlyActiveJson!["activities-minutesLightlyActive"][index]["value"].numberValue
                    let sedentaryValue = sedentaryJson!["activities-minutesSedentary"][index]["value"].numberValue
                    let minutesActive = fairlyActiveJson!["activities-minutesFairlyActive"][index]["value"].int64Value
                        + veryActiveJson!["activities-minutesVeryActive"][index]["value"].int64Value
                    
                    if dataManager.fetchSummaryWith(dateTime) == nil {
                        let summary = DailySummary()
                        summary.dateTime = dateTime
                        summary.steps = stepsValue
                        summary.client = userData
                        summary.distances = distanceValue
                        summary.minutesActive = NSNumber(longLong: minutesActive)
                        summary.minutesLightlyActive = minutesLightlyActiveValue
                        summary.minutesSedentary = sedentaryValue
                        
//                        self.fitbitAPI.getIntradayDataOf("sleep", onDate: dateTime)
//                        self.fitbitAPI.getIntradayDataOf("minutesSedentary", onDate: dateTime)
//                        
//                        while(gettingIntradayDataFlag()){}
//                        
//                        let sedentaryValue = sedentaryJson!["activities-minutesSedentary"][0]["value"].numberValue
//                        summary.minutesSedentary = sedentaryValue
//                        print(sedentaryJson)
//                        print(intradaySleepTimeJson)
//                        
//                        gettingIntradaySleep = true
//                        gettingIntradaySedentary = true
                        
                        dataManager.saveContext()
                    }
                }
            }
        }
    }
    
    func gettingDataFlag() -> Bool {
        return (gettingSteps||gettingDistance||gettingLightlyActive||gettingFairlyActive||gettingVeryActive||gettingSedentary)
    }
    
    func gettingIntradayDataFlag() -> Bool {
        return (gettingIntradaySedentary||gettingIntradaySleep)
    }
    
    func handleDailyOf(dataType: String, data: NSData)
    {
        switch dataType {
            case "steps":
                stepsJson = JSON(data: data)
                gettingSteps = false
            case "distance":
                distancesJson = JSON(data: data)
                gettingDistance = false
            case "minutesLightlyActive":
                lightlyActiveJson = JSON(data: data)
                gettingLightlyActive = false
            case "minutesFairlyActive":
                fairlyActiveJson = JSON(data: data)
                gettingFairlyActive = false
            case "minutesVeryActive":
                veryActiveJson = JSON(data: data)
                gettingVeryActive = false
            case "minutesSedentary":
                sedentaryJson = JSON(data: data)
                gettingSedentary = false
            default:
                break
        }
    }
    
    func handleIntradayOf(dataType: String, data: NSData) {
        switch dataType {
            case "sleep":
                intradaySleepTimeJson = JSON(data: data)
                gettingIntradaySleep = false
            case "minutesSedentary":
                sedentaryJson = JSON(data: data)
                gettingIntradaySedentary = false
            default:
                break
        }
        
        
    }
    
    
}