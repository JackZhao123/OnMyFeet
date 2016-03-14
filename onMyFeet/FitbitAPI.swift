//
//  FitbitAPI.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-17.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import Alamofire

protocol FitbitAPIDelegate {
    func handleDailyOf(dataType: String, data: NSData)
    func handleIntradayOf(dataType: String, data: NSData)
    func handleDailySummary(data: NSData, dateTime: String)
    func handleMinutesAsleep(data: NSData)
}

class FitbitAPI: NSObject,NSURLSessionDataDelegate, NSURLSessionDelegate {
    
    //MARK: Properties
//    static let authenticationURL = "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=227GMP&redirect_uri=onmyfeet://&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight"
    
    let authorizationHost = "https://api.fitbit.com/oauth2/token"
    let clientId = "227GMP"
    let clientSecret = "755f5530f04ceff8679b3c99fec416ef"
    let contentType = "application/x-www-form-urlencoded"
    
    let requestTokenBody = "client_id=227GMP&grant_type=authorization_code&redirect_uri=onmyfeet://&code="
    let refreshTokenBody = "grant_type=refresh_token&refresh_token="
    static var requestNum = 0
    
    let apiRequest = NSMutableURLRequest()
    
    var delegate:FitbitAPIDelegate?
    
    //MARK: Token & Code
    var encodedSecret: String? {
        return "\(clientId):\(clientSecret)".dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
    }
    
    var accessToken: String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("AccessToken") as? String
    }
    
    var refreshCode: String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") as? String
    }
    
    var authorizationCode: String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("AuthorizationCode") as? String
    }
    
    class func sharedAPI() -> FitbitAPI {
        struct Static {
            static let instance = FitbitAPI()
        }
        return Static.instance
    }
    
    //MARK: Method
    class func logIn(forceLogIn flag:Bool){
        
        let url: NSURL!
        if flag {
            url = NSURL(string: Constants.Fitbit.AuthenticationURL + "&prompt=login")
        } else {
            url = NSURL(string: Constants.Fitbit.AuthenticationURL)
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func getAuthorizationCodeFromURL(url:NSURL) {
        let authorizationCode = String(url).componentsSeparatedByString("=")[1]
        NSUserDefaults.standardUserDefaults().setObject(authorizationCode, forKey: "AuthorizationCode")
    }
    
    
    //MARK: Request and refresh AccessToken
    func requestAccessToken() {
            let components = NSURLComponents()
            components.scheme = Constants.Fitbit.APIScheme
            components.host = Constants.Fitbit.APIHost
            components.path = Constants.Fitbit.AuthorizationPath
            let url = components.URL
            
            let headerValues = [Constants.FitbitParameterKey.Authorization: Constants.FitbitParameterValue.Authorization,
                Constants.FitbitParameterKey.ContentType: Constants.FitbitParameterValue.ContentType]
            
            let parameters = [Constants.FitbitParameterKey.ClientID: Constants.FitbitParameterValue.ClientID,
                Constants.FitbitParameterKey.GrantTyoe: Constants.FitbitParameterValue.GrantType_AuthorizationCode,
                Constants.FitbitParameterKey.RedirectURI: Constants.FitbitParameterValue.RedirectURI,
                Constants.FitbitParameterKey.AuthorizationCode: Constants.FitbitParameterValue.AuthorizationCode!
            ]
            
            Alamofire.request(.POST, String(url!), headers:headerValues, parameters: parameters).response(completionHandler: {(request, urlrequest, data, error) -> Void in
                if error != nil {
                    print(error)
                }
                
                self.saveAccessOrRefeshTokenFrom(data!)
            })
        }
    
    func refreshAccessToken() {
        let lastAccessTokenTime = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.AccessTokenTime) as? NSDate
        var syncFlag = false
//        print(accessToken)
        
        if let lastAccessTokenTime = lastAccessTokenTime {
            print(lastAccessTokenTime)
            print(NSDate())
            let interval = NSDate().timeIntervalSinceDate(lastAccessTokenTime)
            
            if interval > 3600.0 {
                print("accesstoken expired")
                syncFlag = true
            }
        } else {
            print("First time refreshaccesstoken")
            syncFlag = true
        }
        
        if syncFlag {
                let components = NSURLComponents()
                components.scheme = Constants.Fitbit.APIScheme
                components.host = Constants.Fitbit.APIHost
                components.path = Constants.Fitbit.AuthorizationPath
                let url = components.URL
                
                let headerValues = [Constants.FitbitParameterKey.Authorization: Constants.FitbitParameterValue.Authorization,
                    Constants.FitbitParameterKey.ContentType: Constants.FitbitParameterValue.ContentType ]
                
                let parameters = [Constants.FitbitParameterKey.GrantTyoe: Constants.FitbitParameterValue.GrantType_RefreshToken,
                    Constants.FitbitParameterKey.RefreshToken: Constants.FitbitParameterValue.RefreshCode!
                ]
            
                Alamofire.request(.POST, String(url!), headers:headerValues, parameters: parameters).response(completionHandler: {(request, urlrequest, data, error) -> Void in
                    if error != nil {
                        print(error)
                    }
                    
                    self.saveAccessOrRefeshTokenFrom(data!)
                })
        }
    }
    
    
    //MARK: Save AccessToken & RefreshToken
    func saveAccessOrRefeshTokenFrom(jsonData: NSData) {
        let json = JSON(data: jsonData)
        print(json)
        
        if let accessToken = json["access_token"].string {
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: Constants.UserDefaultsKey.AccessToken)
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: Constants.UserDefaultsKey.AccessTokenTime)
        }
        
        if let refreshCode = json["refresh_token"].string {
            NSUserDefaults.standardUserDefaults().setObject(refreshCode, forKey: Constants.UserDefaultsKey.RefreshCode)
        }
    }
    
    func getFitbitID() {
        let components = NSURLComponents()
        components.scheme = Constants.Fitbit.APIScheme
        components.host = Constants.Fitbit.APIHost
        components.path = Constants.Fitbit.DevicesInfoPath
        
        if let url = components.URL {
            if let accessToken = accessToken {
                let headers = ["Authorization":"Bearer \(accessToken)"]
                
                Alamofire.request(.GET, String(url), headers:headers).response(completionHandler: {(request, urlRequest, data, error) -> Void in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    let json = JSON(data: data!)
                    if NSUserDefaults.standardUserDefaults().valueForKey("CurrentDeviceID") == nil {
                        let value = json[0]["id"].stringValue
                        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "CurrentDeviceID")
                    }
                })

            }
        }
    }
    
    func getUserName() {
        let url = NSURL(string: "https://api.fitbit.com/1/user/-/profile.json")!
        
        let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                do{
                    let jsonData: AnyObject?
                    jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let jsonData = jsonData {
                        if let name = jsonData.objectForKey("user")?.objectForKey("fullName") {
                            NSUserDefaults.standardUserDefaults().setObject(name, forKey: "CurrentUser")
                            print(name)
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
            else {
                print(error)
            }
        }
        
        if let accessToken = accessToken {
            runURLSessionWithURL(url, withHTTPMethod: "GET", headerValues: ["Authorization":"Bearer \(accessToken)"], httpBody: nil, completionHandler: completionHandler)
        }
    }
    
    func getDaily(let typeOfData dataType:String, startDate:String, var toEndDate endDate:String) {
        var dateComponent = endDate
        let url: NSURL!
        var urlString: String!
        let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if let remains = httpResponse.allHeaderFields["fitbit-rate-limit-remaining"] {
                        print(remains)
                    }
                }
                if let delegate = self.delegate {
                    delegate.handleDailyOf(dataType, data: data!)
                }
            } else {
                print(error)
            }
        }
        
        if endDate == "today" {
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            endDate = String(format: "%d-%02d-%02d", components.year,components.month,components.day)
        }
        
        if dataType == "sleep" {
            urlString = "https://api.fitbit.com/1/user/-/sleep/minutesAsleep/date/"
        } else {
            urlString = "https://api.fitbit.com/1/user/-/activities/\(dataType)/date/"
        }
        
        if startDate == endDate {
            //Get one day data
            url = NSURL(string: urlString + "\(dateComponent)/1d.json")
        } else {
            //Get interval data
            dateComponent = startDate + "/\(dateComponent)"
            url = NSURL(string: urlString + "\(dateComponent).json")
        }
        
        if let accessToken = accessToken {
            runURLSessionWithURL(url!, withHTTPMethod: "GET", headerValues: ["Authorization":"Bearer \(accessToken)"], httpBody: nil, completionHandler: completionHandler)
        }
    }
    
    //MARK: Get All Daily Data 
    func getDaily(startDate:String, var toEndDate endDate:String) {
        if endDate == "today" {
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            endDate = String(format: "%d-%02d-%02d", components.year,components.month,components.day)
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = NSCalendar.currentCalendar()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        if let date1 = formatter.dateFromString(startDate), let date2 = formatter.dateFromString(endDate) {
            let interval = Int(date2.timeIntervalSinceDate(date1) / 86400.0)
            print(interval)
            
            if let accessToken = accessToken {
                let headers = [
                    "Authorization":"Bearer \(accessToken)"
                ]
                
//************************************************************************
//*************************** Get Sleep Time *****************************
//************************************************************************
                
                if let url = Constants.Fitbit.getMinutesAsleepURL(startDate, endDate: endDate) {
                    Alamofire.request(.GET, String(url), headers: headers).response(completionHandler: {(request, urlRequest, data, error) -> Void in
                        guard error == nil else {
                            print(error)
                            return
                        }
                        self.delegate?.handleMinutesAsleep(data!)
                    })
                }
                
                
                
//************************************************************************
//**** Use Time Series to get data when interval bigger than 6 days ******
//************************************************************************
                
                if interval >= 6 {
                    for datatype in Constants.dataType {
                        if let url = Constants.Fitbit.getTimeSeriesUrl(datatype, baseDate: startDate, endDate: endDate) {
                            
                            Alamofire.request(.GET, String(url), headers: headers).response(completionHandler: {(request, urlRequest, data, error) -> Void in
                                guard error == nil else {
                                    print(error)
                                    return
                                }
                                print(urlRequest?.allHeaderFields["Fitbit-Rate-Limit-Remaining"])
                                self.delegate?.handleDailyOf(datatype, data: data!)
                            })
                        } else {
                            print("Can't get url")
                        }
                    }
                    
                }
//************************************************************************
//**** Use Time Series to get data when interval less than 6 days ********
//************************************************************************
                else
                {
                    let count = interval + 1
                    for index in 0...count - 1 {
                        let date = date1.dateByAddingTimeInterval(86400.0 * Double(index))
                        let dateString = formatter.stringFromDate(date)
                        
                        if let url = Constants.Fitbit.getDailySummaryURL(dateString) {
                            Alamofire.request(.GET, String(url), headers: headers).response(completionHandler: {(request, urlRequest, data, error) -> Void in
                                guard error == nil else {
                                    print(error)
                                    return
                                }
                                print(urlRequest?.allHeaderFields["Fitbit-Rate-Limit-Remaining"])
                                self.delegate?.handleDailySummary(data!, dateTime: dateString)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func getIntradayDataOf(dataType:String, onDate dateTime:String) {
        let url: NSURL!
        let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                if let delegate = self.delegate {
                    delegate.handleIntradayOf(dataType, data: data)
                }
            }
        }
        
        switch dataType {
            case "sleep":
            url = NSURL(string: "https://api.fitbit.com/1/user/-/sleep/date/\(dateTime).json")
            case "minutesSedentary":
            url = NSURL(string: "https://api.fitbit.com/1/user/-/activities/minutesSedentary/date/\(dateTime)/1d/15min.json")
        default:
            url = NSURL()
            print("Error Data Type")
            break
        }
        
        if let accessToken = accessToken {
            runURLSessionWithURL(url!, withHTTPMethod: "GET", headerValues: ["Authorization":"Bearer \(accessToken)"], httpBody: nil, completionHandler: completionHandler)
        }
    }
    
    func runURLSessionWithURL(url:NSURL, withHTTPMethod method:String, headerValues header:[String: String]?, httpBody body:String?, completionHandler completion: ((data:NSData?, response:NSURLResponse?, error:NSError?)->Void)? ) {
        apiRequest.URL = url
        apiRequest.HTTPMethod = method
        
        //Handle request's HTTPHeader Value
        if let header = header {
            //Set request's HTTPHeaderField Value
            for (headerField, value) in header {
                apiRequest.setValue(value, forHTTPHeaderField: headerField)
            }
        }
        
        //Handle request's HTTPBody Value
        if let body = body {
            apiRequest.HTTPBody = NSString(string: body).dataUsingEncoding(NSUTF8StringEncoding)
            
        }
    
        //Start URLSession
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        let dataTask: NSURLSessionDataTask!
        
        //**************** Sending Request ***********************
        
        if let completion = completion {
            dataTask = urlSession.dataTaskWithRequest(apiRequest, completionHandler: completion)
        } else {
            dataTask = urlSession.dataTaskWithRequest(apiRequest)
        }
        
        dataTask.resume()
    }
    
    //MARK: URLSessionDelegate
//    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
//        if let error = error {
//            print(error)
//        }
//    }
//
//    
//    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        let jsonData: AnyObject?
//        
//        do{
//            jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            if let jsonData = jsonData {
//                print("Refreshing Token" + "\(jsonData)")
//                let refreshCode = jsonData.objectForKey("refresh_token") as? String
//                if let refreshCode = refreshCode {
//                    NSUserDefaults.standardUserDefaults().setObject(refreshCode, forKey: "RefreshCode")
//                    
//                }
//                
//                let accessToken = jsonData.objectForKey("access_token") as? String
//                if let accessToken = accessToken {
//                    NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "AccessToken")
//                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "AccessTokenTime")
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
    
}
