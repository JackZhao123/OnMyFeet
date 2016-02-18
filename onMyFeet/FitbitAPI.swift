//
//  FitbitAPI.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-17.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class FitbitAPI: NSObject,NSURLSessionDataDelegate, NSURLSessionDelegate {
    
    func requestToFitbit(requestType:String, url:NSURL) {
        // create the request
        
        if let access_token = access_token {
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = requestType
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            
            let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
            let dataTask = urlSession.dataTaskWithRequest(request)
            
            dataTask.resume()
        }
        
    }
    
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
                print(jsonData)
            }
        } catch {
            print(error)
        }
    }
    
}
