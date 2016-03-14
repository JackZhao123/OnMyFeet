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
    var summaryJson: JSON?
    
    var client:Person?
    
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
        
        client = userData
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
        
        self.fitbitAPI.getDaily(startDate, toEndDate: endDate)
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
    
    func gettingIntradayDataFlag() -> Bool {
        return (gettingIntradaySedentary||gettingIntradaySleep)
    }
    
    
    //MARK: FitbitAPI delegate
    func handleDailyOf(dataType: String, data: NSData)
    {
        let json = JSON(data: data)
        
            if let key = Constants.Fitbit.FitbitActivitiesDataValueKey[dataType] {
                if (json[key].count > 0) {
                    for index in 0...json[key].count - 1 {
                        let dateTime = json[key][index]["dateTime"].stringValue
                        let value = json[key][index]["value"].numberValue
                        
                        if let summary = dataManager.fetchSummaryWith(dateTime) {
                            summary.client = client
                            
                            if (dataType == "minutesFairlyActive" || dataType == "minutesVeryActive") {
                                if let dataValue = summary.valueForKey("minutesActive") as? NSNumber {
                                    summary.setValue(NSNumber(int: dataValue.intValue + value.intValue), forKey: "minutesActive")
                                } else {
                                    summary.setValue(value, forKey: "minutesActive")
                                }
                            } else {
                                summary.setValue(value, forKey: dataType)
                            }
                            
                        } else {
                            let summary = DailySummary()
                            summary.dateTime = dateTime
                            summary.client = client
                            
                            if (dataType == "minutesFairlyActive" || dataType == "minutesVeryActive") {
                                if let dataValue = summary.valueForKey("minutesActive") as? NSNumber {
                                    summary.setValue(NSNumber(int: dataValue.intValue + value.intValue), forKey: "minutesActive")
                                } else {
                                    summary.setValue(value, forKey: "minutesActive")
                                }
                            } else {
                                summary.setValue(value, forKey: dataType)
                            }
                            
                        }
                        dataManager.saveContext()
                    }
                }
            }
    }
    
    func handleMinutesAsleep(data: NSData) {
        let json = JSON(data: data)

        if let key = Constants.Fitbit.FitbitActivitiesDataValueKey["sleep"] {
            if json[key].count > 0 {
                for index in 0...json[key].count - 1 {
                    let dateTime = json[key][index]["dateTime"].stringValue
                    let sleepValue = json[key][index]["value"].numberValue
                    
                    if let summary = ClientDataManager.sharedInstance().fetchSummaryWith(dateTime) {
                        summary.client = client
                        summary.minutesAsleep = sleepValue
                    } else {
                        let summary = DailySummary()
                        summary.client = client
                        summary.minutesAsleep = sleepValue
                    }
                }
            }
        }
    }
    
    func handleIntradayOf(dataType: String, data: NSData) {
        switch dataType {
            case "sleep":
                intradaySleepTimeJson = JSON(data: data)
                gettingIntradaySleep = false
            case "minutesSedentary":
                sedentaryJson = JSON(data: data)
                gettingSedentary = false
            default:
                break
        }
    }
    
    func handleDailySummary(data: NSData, dateTime:String) {
        let json = JSON(data: data)
        getDataFromSummary(json, dateTime: dateTime)
    }
    
    func getDataFromSummary(jsonData: JSON, dateTime: String) {
        let stepsValue = jsonData["summary"]["steps"].numberValue
        let distanceValue = jsonData["summary"]["distances"][0]["distance"].numberValue
        
        let minutesLightlyActiveValue = jsonData["summary"]["lightlyActiveMinutes"].numberValue
        let sedentaryValue = jsonData["summary"]["sedentaryMinutes"].numberValue
        let minutesActive = jsonData["summary"]["veryActiveMinutes"].int64Value + jsonData["summary"]["fairlyActiveMinutes"].int64Value
        
        if let summary = dataManager.fetchSummaryWith(dateTime) {
            summary.dateTime = dateTime
            summary.steps = stepsValue
            summary.distance = distanceValue
            summary.minutesActive = NSNumber(longLong: minutesActive)
            summary.minutesLightlyActive = minutesLightlyActiveValue
            summary.minutesSedentary = sedentaryValue
            summary.client = client
        }else {
            let summary = DailySummary()
            summary.dateTime = dateTime
            summary.steps = stepsValue
            summary.distance = distanceValue
            summary.minutesActive = NSNumber(longLong: minutesActive)
            summary.minutesLightlyActive = minutesLightlyActiveValue
            summary.minutesSedentary = sedentaryValue
            summary.client = client
        }
        dataManager.saveContext()
        setLastUpdateTime()
    }
}