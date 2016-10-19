//
//  DataItem.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class DataItem: NSObject {
    var title: String
    var date: String {
        didSet{
            self.setNumber()
        }
    }
    var number: Double
    var activeNum: Double
    var sedentaryNum: Double
    var lightlyNum: Double
    
    var firstDayOfWeek = "2016-03-20"
    var lastDayOfWeek = "2016-03-26"
    var weeklyData: [Double] = [0,0,0,0,0,0,0]
    var weeklyActive: [Double] = [0,0,0,0,0,0,0]
    var weeklyLightly: [Double] = [0,0,0,0,0,0,0]
    
  
    init(title:String, date:String) {
        self.title = title
        self.date = date
        self.number = 0
        self.activeNum = 0
        self.sedentaryNum = 0
        self.lightlyNum = 0
        super.init()
        let temList = DateStruct.getWeekDay()
        self.firstDayOfWeek = temList[0]
        self.lastDayOfWeek = temList[1]
        self.setNumber()
        self.getWeeklyData()
    }
    
    func setNumber(){
//        let titleDictionary = ["Steps":"steps", "Distance":"distance","Sleep Hours":"minutesAsleep", "Intensity":"minutesSedentary"]
//        let key = titleDictionary[title]
//        
//        let dailySummary = ClientDataManager.sharedInstance().fetchSummaryWith(date)
//        if let dailySummary = dailySummary {
//        let active = dailySummary.value(forKey: "minutesActive")
//        let sedentary = dailySummary.value(forKey: "minutesSedentary")
//        let lightly = dailySummary.value(forKey: "minutesLightlyActive")
//        
//        if let active = active {
//            self.activeNum = active as! Double
//        }
//        
//        if let sedentary = sedentary {
//            self.sedentaryNum = sedentary as! Double
//        }
//        
//        if let lightly = lightly {
//            self.lightlyNum = lightly as! Double
//        }
//        
//        
//            if let key = key {
//                let num = dailySummary.value(forKey: key)
//                if let num = num {
//                    self.number = num as! Double
//                }
//            }
//        } else {
//            activeNum = 0
//            sedentaryNum = 0
//            lightlyNum = 0
//            number = 0
//        }
    }
    
    func getWeeklyData() {
//        var startDate = firstDayOfWeek
//        weeklyData = [0,0,0,0,0,0,0]
//        weeklyActive = [0,0,0,0,0,0,0]
//        weeklyLightly = [0,0,0,0,0,0,0]
//        
//        let titleDictionary = ["Steps":"steps", "Distance":"distance","Sleep Hours":"minutesAsleep", "Intensity":"minutesSedentary"]
//        let key = titleDictionary[title]
//        
//        if let key = key {
//            for i in 0..<7 {
//                let summary = ClientDataManager.sharedInstance().fetchSummaryWith(startDate)
//                if let num = summary?.value(forKey: key) {
//                    var temp = num as! Double
//                    if title == "Distance" {
//                        temp = temp * 1000
//                    }
//                    
//                    if title == "Sleep Hours" {
//                        temp = temp / 60
//                    }
//                    weeklyData[i] = temp
//                }
//                
//                if key == "minutesSedentary" {
//                    if let num = summary?.value(forKey: "minutesLightlyActive") {
//                        weeklyLightly[i] = num as! Double
//                    }
//                    
//                    if let num = summary?.value(forKey: "minutesActive") {
//                        weeklyActive[i] = num as! Double
//                    }
//                }
//                startDate = DateStruct.dateValueChangeFrom(startDate, by: 1)
//            }
//        }
    }
    
}
