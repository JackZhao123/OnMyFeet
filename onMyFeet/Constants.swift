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
    
    struct develop {
        static var startTime = "2016-03-01"
        static var endTime = "today"
        static var ifGetIntraday = false
        static var ifGetStepDistance = false
    }
    
    struct Fitbit {
        static let APIScheme = "https"
        static let APIHost = "api.fitbit.com"
        static let APIPath = "/1/user/-"
        static let AuthorizationPath = "/oauth2/token"
        static let DevicesInfoPath = "/1/user/-/devices.json"
        static var id = "11111111"
        
        static let AuthenticationURL = "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=227GMP&redirect_uri=onmyfeet://&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight"
        
        
        static let ActivitiesTimeSeriesPathFormat = "/1/user/-/%@/date/%@/%@.json"
        static let DailySummaryPathFormat = "/1/user/-/activities/date/%@.json"
        static let SleepTimeSeriesPathFormat = "/1/user/-/sleep/minutesAsleep/date/%@/%@.json"
        
        static let FitbitActivitiesDataValueKey = [
            "steps":"activities-steps",
            "distance":"activities-distance",
            "minutesLightlyActive":"activities-minutesLightlyActive",
            "minutesFairlyActive":"activities-minutesFairlyActive",
            "minutesVeryActive":"activities-minutesVeryActive",
            "minutesSedentary":"activities-minutesSedentary",
            "sleep":"sleep-minutesAsleep"
        ]
        
        static func getTimeSeriesUrl(_ resourcePath:String?, baseDate:String, endDate:String) -> URL? {
            var activitiesPath: String?
            if let resourcePath = resourcePath {
                activitiesPath = "activities/" + resourcePath
            } else {
                activitiesPath = "activities"
            }
            
            let apiPath = String(format: ActivitiesTimeSeriesPathFormat, arguments: [activitiesPath!,baseDate,endDate])
            var components = URLComponents()
            components.scheme = APIScheme
            components.host = APIHost
            components.path = apiPath
            
            return components.url
        }
        
        static func getDailySummaryURL(_ dateTime:String) -> URL? {
            let apiPath = String(format: DailySummaryPathFormat, arguments: [dateTime])
            var components = URLComponents()
            components.scheme = APIScheme
            components.host = APIHost
            components.path = apiPath
            
            return components.url
        }
        
        static func getMinutesAsleepURL(_ baseDate:String, endDate:String) -> URL? {
            let apiPath: String?
            apiPath = String(format: SleepTimeSeriesPathFormat, arguments: [baseDate,endDate])
            
            var components = URLComponents()
            components.scheme = APIScheme
            components.host = APIHost
            components.path = apiPath!
            
            return components.url
        }
    }
    
    struct FitbitParameterKey {
        static let ClientID = "client_id"
        static let GrantTyoe = "grant_type"
        static let RedirectURI = "redirect_uri"
        static let RefreshToken = "refresh_token"
        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
        static let AuthorizationCode = "code"
    }
    
    struct FitbitParameterValue {
        static let ClientID = "227GMP"
        static let GrantType_AuthorizationCode = "authorization_code"
        static let GrantType_RefreshToken = "refresh_token"
        static let ContentType = "application/x-www-form-urlencoded"
        static let ContetnType_Content = "contentType"
        static let ClientSecret = "755f5530f04ceff8679b3c99fec416ef"
        static let RedirectURI = "onmyfeet://"
        
        
        static var Authorization: String {
                return "Basic \(EncodedSecret!)"
        }
        
        static var EncodedSecret: String? {
            return "\(ClientID):\(ClientSecret)".data(using: String.Encoding.utf8)?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        }
        
        static var AuthorizationCode: String? {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.AuthorizationCode) as? String
        }
        static var AccessToken: String? {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.AccessToken) as? String
        }
        static var RefreshCode: String? {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.RefreshCode) as? String
        }
    }
    
    struct UserDefaultsKey {
        static let AuthorizationCode = "AuthorizationCode"
        static let AccessToken = "AccessToken"
        static let RefreshCode = "RefreshCode"
        static let AccessTokenTime = "AccessTokenTime"
        static let FitbitID = "CurrentDeviceID"
    }
    
    
    
    
}
