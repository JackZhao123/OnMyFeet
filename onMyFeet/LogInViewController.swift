//
//  LogInViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import SafariServices

class LogInViewController: UIViewController {
    let screenHeight = UIScreen.main.bounds.height
    
      //MARK: Outlets
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var appLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInBtn.layer.cornerRadius = 8.0;
        logInBtn.clipsToBounds = true;
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didBecomeActive() {
            if UserDefaults.standard.object(forKey: "RefreshCode") != nil {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func logIn(_ sender: AnyObject) {
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
