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
    var finish = true
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    
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
            self.fitbitAPI.getStepsFrom("2016-01-01", toEndDate: "today")
        } else {
            print("Update Needed Data")
        }
        
        while(finish){
            
        }
        if let stepsJson = stepsJson {

            for index in 0...stepsJson["activities-steps"].count - 1 {
                
                let dateTime = stepsJson["activities-steps"][index]["dateTime"].stringValue
                let stepsValue = stepsJson["activities-steps"][index]["value"].numberValue
                
                if dataManager.fetchSummaryWith(dateTime) == nil {
                    let summary = DailySummary()
                    summary.dateTime = dateTime
                    summary.steps = stepsValue
                    dataManager.saveContext()
                }
            }
        }
    }
    
    func handleDailyStepsData(data: NSData) {
        stepsJson = JSON(data: data)
        print(stepsJson)
        finish = false
    }
}