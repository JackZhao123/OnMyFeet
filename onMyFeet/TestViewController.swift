//
//  TestViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-14.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var displayTextView: UITextView!
    
    override func viewDidLoad() {
        displayTextView.text = "AccessToken: Nil\n RefreshCode: Nil"
    }
    
    @IBAction func sendSteps(sender: AnyObject) {
        
    }
    
    @IBAction func getSystemToken(sender: AnyObject) {
        let accessToken = Constants.FitbitParameterValue.AccessToken
        let refreshCode = Constants.FitbitParameterValue.RefreshCode
        if let accessToken = accessToken, let refreshCode = refreshCode {
            displayTextView.text = "AccessToken: \(accessToken)\nRefreshCode: \(refreshCode)"
            print(displayTextView.text)
        } else {
            displayTextView.text = "AccessToken: Nil\n RefreshCode: Nil"
        }
    }
    
    @IBAction func refreshToken(sender: AnyObject) {
        FitbitAPI.sharedAPI().refreshAccessToken()
    }
    
    
    
}
