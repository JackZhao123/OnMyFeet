//
//  FitbitAPI.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-17.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

protocol FitbitAPIDelegate {
    func handleDailyStepsData(data:NSData)
}

class FitbitAPI: NSObject,NSURLSessionDataDelegate, NSURLSessionDelegate {
    
    //MARK: Properties
    static let authenticationURL = "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=227GMP&redirect_uri=onmyfeet://&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight"
    
    let authorizationHost = "https://api.fitbit.com/oauth2/token"
    let clientId = "227GMP"
    let clientSecret = "755f5530f04ceff8679b3c99fec416ef"
    let contentType = "application/x-www-form-urlencoded"
    
    let requestTokenBody = "client_id=227GMP&grant_type=authorization_code&redirect_uri=onmyfeet://&code="
    let refreshTokenBody = "grant_type=refresh_token&refresh_token="
    
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
            url = NSURL(string: authenticationURL + "&prompt=login")
        } else {
            url = NSURL(string: authenticationURL)
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func getAuthorizationCodeFromURL(url:NSURL) {
        let authorizationCode = String(url).componentsSeparatedByString("=")[1]
        NSUserDefaults.standardUserDefaults().setObject(authorizationCode, forKey: "AuthorizationCode")
    }
    
    func requestAccessToken() {
        
        if let authorizationCode = authorizationCode {
            let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if error == nil {
                    let json = JSON(data: data!)
                    let refreshCode = json["refresh_token"].stringValue
                    NSUserDefaults.standardUserDefaults().setObject(refreshCode, forKey: "RefreshCode")
                }
            }
            
            if let encodedSecret = encodedSecret {
                let url = NSURL(string: authorizationHost)
                let headerValues = ["Authorization":"Basic \(encodedSecret)", "Content-Type": contentType]
                let body = requestTokenBody + authorizationCode
                runURLSessionWithURL(url!, withHTTPMethod: "POST", headerValues: headerValues, httpBody: body, completionHandler: completionHandler)
            }
        }
    }
    
    
    func refreshAccessToken() {

        if let refreshCode = refreshCode {
            let url = NSURL(string: authorizationHost)
            let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if error == nil {
                    let json = JSON(data: data!)
                    let accessToken = json["access_token"].stringValue
                    NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "AccessToken")
                }
            }
            
            if let encodedSecret = encodedSecret {
                let headerValues = ["Authorization":"Basic \(encodedSecret)", "Content-Type": contentType]
                let body = refreshTokenBody + refreshCode
                
                runURLSessionWithURL(url!, withHTTPMethod: "POST", headerValues: headerValues, httpBody: body, completionHandler: completionHandler)
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
    
    func getStepsFrom(startDate:String, toEndDate endDate:String) {
        var dateComponent = endDate
        let url: NSURL!
        let completionHandler = {(data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                if let delegate = self.delegate {
                    delegate.handleDailyStepsData(data!)
                }
            } else {
                print(error)
            }
        }
        
        if startDate == endDate {
            //Get one day data
            url = NSURL(string: "https://api.fitbit.com/1/user/-/activities/steps/date/\(dateComponent)/1d.json")
        } else {
            //Get interval data
            dateComponent = startDate + "/\(dateComponent)"
            url = NSURL(string: "https://api.fitbit.com/1/user/-/activities/steps/date/\(dateComponent).json")
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
        if let completion = completion {
            dataTask = urlSession.dataTaskWithRequest(apiRequest, completionHandler: completion)
        } else {
            dataTask = urlSession.dataTaskWithRequest(apiRequest)
        }
        
        dataTask.resume()
    }
    
    
    //MARK: URLSessionDelegate
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let error = error {
            print(error)
        }
    }

    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {

    }
    
}
