//
//  JSONHandler.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-12.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

struct simpleSleepData {
    var dateTime: String
    var startTime: String
    var endTime: String
    var sleepValues: [Int]
}

class JSONHandler {
    static func handlerIntradaySleepJson(sleepJSON:JSON?) -> [simpleSleepData] {
        var result = [simpleSleepData]()

        if let sleepJSON = sleepJSON {
            let sleepCount = sleepJSON["sleep"].count
            if sleepCount > 0 {
                
                for index in 0...sleepCount - 1 {
                    let startTimeString = sleepJSON["sleep"][index]["startTime"].stringValue.componentsSeparatedByString("T")
                    let dateTime = startTimeString[0]
                    let startTime = startTimeString[1].substringToIndex(startTimeString[1].startIndex.advancedBy(8))
                    let sleepValuesCount = sleepJSON["sleep"][index]["minuteData"].count
                    var sleepValues = [Int]()
                    for i in 0...sleepValuesCount - 1 {
                        let value = sleepJSON["sleep"][index]["minuteData"][i]["value"].intValue
                        sleepValues.append(value)
                    }
                    let formatter = NSDateFormatter()
                    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                    formatter.dateFormat = "HH:mm:ss"
                    let date = formatter.dateFromString(startTime)
                    
                    let endTime = formatter.stringFromDate((date?.dateByAddingTimeInterval(NSTimeInterval(sleepValues.count * 60)))!)
                    
                    let simpleData = simpleSleepData(dateTime: dateTime, startTime: startTime, endTime: endTime, sleepValues: sleepValues)
                    result.append(simpleData)
                    
                }
            }
        }
        
        return result
    }
    
    
    
    
    
    
}