//
//  FitbitAPI.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-17.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class FitbitAPI: NSObject,NSURLSessionDataDelegate, NSURLSessionDelegate {
    
    let authorizationHost = "https://api.fitbit.com/oauth2/token"
    let clientId = "227GMP"
    let clientSecret = "755f5530f04ceff8679b3c99fec416ef"
    let contentType = "application/x-www-form-urlencoded"
    
    let requestTokenBody = "client_id=227GMP&grant_type=authorization_code&redirect_uri=onmyfeet://&code="
    let refreshTokenBody = "grant_type=refresh_token&refresh_token="
    
    func getAuthorizationCodeFromURL(url:NSURL) {
        let authorizationCode = String(url).componentsSeparatedByString("=")[1]
        NSUserDefaults.standardUserDefaults().setObject(authorizationCode, forKey: "AuthorizationCode")
    }
    
    func requestAccessToken() {
        let authorizationCode = NSUserDefaults.standardUserDefaults().objectForKey("AuthorizationCode") as? String
        
        if let authorizationCode = authorizationCode {

            let request = NSMutableURLRequest(URL: NSURL(string: authorizationHost)!)
            request.HTTPMethod = "POST"
            
            let userInfo = NSString(string: "\(clientId):\(clientSecret)")
            let encodedString = userInfo.dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            
            if let encodedString = encodedString {
                
                request.setValue("Basic \(encodedString)", forHTTPHeaderField: "Authorization")
                request.setValue( contentType , forHTTPHeaderField: "Content-Type")
                request.HTTPBody = NSString(string: requestTokenBody + authorizationCode).dataUsingEncoding(NSUTF8StringEncoding)
                
                let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
                let dataTask = urlSession.dataTaskWithRequest(request)
                
                dataTask.resume()
            }
        }
    }
    
    func refreshAccessToken() {
        let refreshCode = NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") as? String
        
        if let refreshCode = refreshCode {
            
            let request = NSMutableURLRequest(URL: NSURL(string: authorizationHost)!)
            request.HTTPMethod = "POST"
            
            let userInfo = NSString(string: "\(clientId):\(clientSecret)")

            let encodedString = userInfo.dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            
            if let encodedString = encodedString {
                
                request.setValue("Basic \(encodedString)", forHTTPHeaderField: "Authorization")
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                request.HTTPBody = NSString(string: refreshTokenBody + refreshCode).dataUsingEncoding(NSUTF8StringEncoding)
                
                let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
                let dataTask = urlSession.dataTaskWithRequest(request)
                
                dataTask.resume()
            }
        }

    }
    
    func sync(){
        
    }
    
    //MARK: URLSessionDelegate
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let error = error {
            print(error)
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        let jsonData: AnyObject?
        
        do{
            jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let jsonData = jsonData {
                
                let refreshCode = jsonData.objectForKey("refresh_token") as? String
                if let refreshCode = refreshCode {
                    NSUserDefaults.standardUserDefaults().setObject(refreshCode, forKey: "RefreshCode")
                }
            }
        } catch {
            print(error)
        }
    }
    
}
