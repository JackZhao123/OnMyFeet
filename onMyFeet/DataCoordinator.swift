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
    var dailySleepJson: JSON?
    
    // Flag
    var gettingSleep = true
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
    
    
    //MARK: Fetching Data
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
            let dateTime = "2016-02-01"
            print("Load All Data From \(dateTime)")
            getDataFrom(dateTime, toEndDate: "today")

        } else {
            let currentUser = NSUserDefaults.standardUserDefaults().objectForKey("CurrentUser") as! String
            let key = "\(currentUser)_UpdateTime"
            let lastUpdated = NSUserDefaults.standardUserDefaults().objectForKey(key) as! String
            print("Update Data From \(lastUpdated)")
            getDataFrom(lastUpdated, toEndDate: "today")

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
                    let sleepValue = dailySleepJson!["sleep-minutesAsleep"][index]["value"].numberValue
                    
                    if let summary = dataManager.fetchSummaryWith(dateTime) {
                        summary.dateTime = dateTime
                        summary.steps = stepsValue
                        summary.client = userData
                        summary.distances = distanceValue
                        summary.minutesActive = NSNumber(longLong: minutesActive)
                        summary.minutesLightlyActive = minutesLightlyActiveValue
                        summary.minutesSedentary = sedentaryValue
                        summary.sleepTime = sleepValue
                        
                    } else {
                        let summary = DailySummary()
                        summary.dateTime = dateTime
                        summary.steps = stepsValue
                        summary.client = userData
                        summary.distances = distanceValue
                        summary.minutesActive = NSNumber(longLong: minutesActive)
                        summary.minutesLightlyActive = minutesLightlyActiveValue
                        summary.minutesSedentary = sedentaryValue
                        summary.sleepTime = sleepValue
                    }
                    dataManager.saveContext()

                }
            }
        }
        
        setLastUpdateTime()
    }
    
    func setLastUpdateTime() {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        let lastUpdateTime = String(format: "%d-%02d-%02d", components.year,components.month,components.day)
        let currentUser = NSUserDefaults.standardUserDefaults().objectForKey("CurrentUser") as! String
        let key = "\(currentUser)_UpdateTime"
        NSUserDefaults.standardUserDefaults().setObject(lastUpdateTime, forKey: key)
    }
    
    func getDataFrom(startDate: String, toEndDate endDate: String) {
        self.fitbitAPI.getDaily(typeOfData: "steps", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "distance", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "minutesLightlyActive", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "minutesFairlyActive", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "minutesVeryActive", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "minutesSedentary", startDate: startDate, toEndDate: endDate)
        self.fitbitAPI.getDaily(typeOfData: "sleep", startDate: startDate, toEndDate: endDate)
    }
    
    func getIntradayData() {
        let dateTime = "2016-03-02"
        self.fitbitAPI.delegate = self
        self.fitbitAPI.getIntradayDataOf("sleep", onDate: dateTime)
        
        while(gettingIntradaySleep){}
        
        if let intradaySleepTimeJson = intradaySleepTimeJson {
            if intradaySleepTimeJson["sleep"].count > 0 {
                
                    let intradaySleep = IntradaySleepTime()
                    intradaySleep.dateTime = dateTime
                    
                    do {
                        let data = try intradaySleepTimeJson.rawData()
                        intradaySleep.sleepJson = data
                    } catch {
                        print(error)
                    }
                    dataManager.saveContext()
            }
        }
    }
    
    func getIntradaySedentary() {
        let dateTime = "2016-03-02"
        self.fitbitAPI.delegate = self
        self.fitbitAPI.getIntradayDataOf("minutesSedentary", onDate: dateTime)
        
        while(gettingSedentary){}
        
        if let sedentaryJson = sedentaryJson {
            if sedentaryJson["activities-minutesSedentary-intraday"]["dataset"].count > 0 {
                
                for index in 0...sedentaryJson["activities-minutesSedentary-intraday"]["dataset"].count - 1 {
                    let time = sedentaryJson["activities-minutesSedentary-intraday"]["dataset"][index]["time"].stringValue
                    let sedentaryValue = sedentaryJson["activities-minutesSedentary-intraday"]["dataset"][index]["value"].numberValue
                    
                    if let intradaySedentary = dataManager.fetchDataOf("IntradaySedentary", parameter: ["dateTime", "time"], argument: [dateTime, time]) as? [IntradaySedentary]{
                        if intradaySedentary.count > 0 {
                            intradaySedentary.first?.time = time
                            intradaySedentary.first?.value = sedentaryValue
                            intradaySedentary.first?.dateTime = dateTime
                        } else {
                            let intradaySedentary = IntradaySedentary()
                            intradaySedentary.time = time
                            intradaySedentary.value = sedentaryValue
                            intradaySedentary.dateTime = dateTime
                        }
                    }
                 
                    dataManager.saveContext()
                }
            }
        }
    }
    
    
    //MARK: Flag
    func gettingDataFlag() -> Bool {
        return (gettingSteps||gettingDistance||gettingLightlyActive||gettingFairlyActive||gettingVeryActive||gettingSedentary||gettingSleep)
    }
    
    func gettingIntradayDataFlag() -> Bool {
        return (gettingIntradaySedentary||gettingIntradaySleep)
    }
    
    
    //MARK: FitbitAPI delegate
    func handleDailyOf(dataType: String, data: NSData)
    {
//        let json = JSON(data: data)
        //print(json)
        switch dataType {
            case "steps":
                stepsJson = JSON(data: data)
                gettingSteps = false
                print(stepsJson)
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
            case "sleep":
                dailySleepJson = JSON(data: data)
                gettingSleep = false
            default:
                break
        }
    }
    
    func handleIntradayOf(dataType: String, data: NSData) {
        switch dataType {
            case "sleep":
                intradaySleepTimeJson = JSON(data: data)
                gettingIntradaySleep = false
                print(intradaySleepTimeJson)
            case "minutesSedentary":
                sedentaryJson = JSON(data: data)
                gettingSedentary = false
                //print(sedentaryJson)
            default:
                break
        }
    }
}