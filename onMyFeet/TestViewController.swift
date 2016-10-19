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
    @IBOutlet weak var idLabel: UILabel!
    
    
    override func viewDidLoad() {
        displayTextView.text = "AccessToken: Nil\n RefreshCode: Nil"
        idLabel.text = "Current FitbitID: \(Constants.Fitbit.id)"
    }
    
    @IBAction func wipeAllData(_ sender: AnyObject) {
    }
    
    @IBAction func getSendingStatus(_ sender: AnyObject) {
        var intradayStatus = "false"
        var stepDistanceStatus = "false"
        if Constants.develop.ifGetIntraday {
            intradayStatus = "True"
        }
        
        if Constants.develop.ifGetStepDistance {
            stepDistanceStatus = "true"
        }
        
        let displayString = "IntradayStatus: \(intradayStatus) \nStepDistanceStatus: \(stepDistanceStatus)"
        displayTextView.text = displayString
    }
    
    
    @IBAction func changeDistance(_ sender: AnyObject) {
        let b = Constants.develop.ifGetStepDistance
        Constants.develop.ifGetStepDistance = !b
        getSendingStatus(self)
    }
    
    @IBAction func changeIntraday(_ sender: AnyObject) {
        let b = Constants.develop.ifGetIntraday
        Constants.develop.ifGetIntraday = !b
        getSendingStatus(self)
    }
    
    
    @IBAction func setToOne(_ sender: AnyObject) {
        Constants.Fitbit.id = "11111111"
        idLabel.text = "Current FitbitID: \(Constants.Fitbit.id)"
    }

    @IBAction func setToZero(_ sender: AnyObject) {
        Constants.Fitbit.id = "00000000"
        idLabel.text = "Current FitbitID: \(Constants.Fitbit.id)"
    }
    
    
    @IBAction func getSystemToken(_ sender: AnyObject) {
        let accessToken = Constants.FitbitParameterValue.AccessToken
        let refreshCode = Constants.FitbitParameterValue.RefreshCode
        if let accessToken = accessToken, let refreshCode = refreshCode {
            displayTextView.text = "AccessToken: \(accessToken)\nRefreshCode: \(refreshCode)"
            print(displayTextView.text)
        } else {
            displayTextView.text = "AccessToken: Nil\n RefreshCode: Nil"
        }
    }
    
    @IBAction func refreshToken(_ sender: AnyObject) {
    }
    
    
    
}
