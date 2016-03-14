//
//  constants.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-13.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

struct Constants {
    static let dataType = ["steps", "distance", "minutesLightlyActive", "minutesFairlyActive", "minutesVeryActive", "minutesSedentary"]
    
    struct Fitbit {
        static let APIScheme = "https"
        static let APIHost = "api.fitbit.com"
        static let APIPath = "/1/user/-"
        
        static let ActivitiesTimeSeriesPathFormat = "/1/user/-/%@/date/%@/%@.json"
        static let DailySummaryPathFormat = "/1/user/-/activities/date/%@.json"
        
        static let FitbitActivitiesDataValueKey = [
            "steps":"activities-steps",
            "distance":"activities-distance",
            "minutesLightlyActive":"activities-minutesLightlyActive",
            "minutesFairlyActive":"activities-minutesFairlyActive",
            "minutesVeryActive":"activities-minutesVeryActive",
            "minutesSedentary":"activities-minutesSedentary"
        ]
        
        static func getTimeSeriesUrl(resourcePath:String?, baseDate:String, endDate:String) -> NSURL? {
            var activitiesPath: String?
            if let resourcePath = resourcePath {
                activitiesPath = "activities/".stringByAppendingString(resourcePath)
            } else {
                activitiesPath = "activities"
            }
            
            let apiPath = String(format: ActivitiesTimeSeriesPathFormat, arguments: [activitiesPath!,baseDate,endDate])
            let components = NSURLComponents()
            components.scheme = APIScheme
            components.host = APIHost
            components.path = apiPath
            
            return components.URL
        }
        
        static func getDailySummaryURL(dateTime:String) -> NSURL? {
            let apiPath = String(format: DailySummaryPathFormat, arguments: [dateTime])
            let components = NSURLComponents()
            components.scheme = APIScheme
            components.host = APIHost
            components.path = apiPath
            
            return components.URL
        }
    }
    
//    struct FitbitActivitiesDataValueKey {
//        static let
//    }
    
    
    
}