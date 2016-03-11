//
//  BackendOperation.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import Alamofire

class BackendOperation {
    
    static func getStepsDataWith(dateTime: String) {
        
    }
    
    static func postData() {
        let parameters = [
            "stepsData": ["2016-03-02":"2000"]
        ]
        
        Alamofire.request(.POST, "http://do.zhaosiyang.com:3000/dataUpload", parameters: parameters, encoding: .JSON).responseString(completionHandler: {response in
            print("Response, \(response.result.value)")
        })
    }
}