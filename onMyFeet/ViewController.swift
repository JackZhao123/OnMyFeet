//
//  ViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-15.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
//    MARK: Outlet
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var indicatiorView: UIView!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    
//    MARK: Properties
    var userInfo: String!
    var categories = ["My Goals", "Monitoring Progress", "Checking in", "Taking Action"]
    var refreshControl: UIRefreshControl!
    
//    MARK: view initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl.backgroundColor = UIColor(red: 0.831, green: 0.859, blue: 0.710, alpha: 1.00)
//        self.refreshControl.tintColor = UIColor.grayColor()
//        
//        self.refreshControl.attributedTitle = NSAttributedString(string:"Push to refresh", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
//        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
//        
//        self.menuTableView.addSubview(refreshControl)
        
        indicatiorView.layer.cornerRadius = 8.0
        indicatiorView.clipsToBounds = true
        hideIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let info = NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") as? String {
//            self.userInfo = info
//        } else {
//            let logInController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as! LogInViewController
//            self.presentViewController(logInController, animated: false, completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.categoryName.text = categories[(indexPath as NSIndexPath).row]
        if (indexPath as NSIndexPath).row == 4 {
            
            cell.categoryName.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = self.menuTableView.frame.height - 64;
        return (tableViewHeight / (CGFloat)(categories.count));
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var storyboardIdentifier: String?
        switch (indexPath as NSIndexPath).row {
        case 0:
            storyboardIdentifier = "ViewGoalsViewController"
        default:
            storyboardIdentifier = nil
        }
        
        if let storyboardIdentifier = storyboardIdentifier {
            let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
            self.navigationController!.pushViewController(desController, animated: true)
        }
        
        menuTableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    //MARK: Indicator
    func showIndicator() {
        mIndicator.startAnimating()
        indicatiorView.isHidden = false
    }
    
    func hideIndicator() {
        indicatiorView.isHidden = true
        mIndicator.stopAnimating()
    }
    //MARK: Actions

    @IBAction func logOut(_ sender: AnyObject) {
        
        let finishAlertController = UIAlertController(title: "Successfully Deleted All Goals and Activities", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (okAction) in
            finishAlertController.dismiss(animated: true, completion: nil)
        })
        finishAlertController.addAction(okAction)
        
        let resetAlertController = UIAlertController(title: "Reset All Data", message: "This operation cannot be undone", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(cancelAction) in
            resetAlertController.dismiss(animated: true, completion: nil)
        })
        let resetDataAction = UIAlertAction(title: "Reset All Goals and Activities", style: .destructive, handler: {
            (resetDataAction) in
            Goal.mr_truncateAll()
            Activity.mr_truncateAll()
            ActivityProgress.mr_truncateAll()
            self.present(finishAlertController, animated: true, completion: nil)
        })
        
        resetAlertController.addAction(cancelAction)
        resetAlertController.addAction(resetDataAction)
        self.present(resetAlertController, animated: true, completion: nil)
//        let alertView = UIAlertController(title: "Logging Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
//        alertView.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {(action) in
//            
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("RefreshCode")
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LogOutManually")
//            
//            let logInController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as! LogInViewController
//            self.presentViewController(logInController, animated: true, completion: nil)
//            
//        }))
//        
//        alertView.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {(action) in
//            alertView.dismissViewControllerAnimated(true, completion: nil)
//        }))
//        
//        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func syncData(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "fitbit://")!)
        self.scheduleLocal(self)
    }
    
    func refresh() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func scheduleLocal(_ sender: AnyObject) {
        let setting = UIApplication.shared.currentUserNotificationSettings
        
        if setting?.types == .none {
            let ac = UIAlertController(title: "Can't Schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.alertBody = "Get back to OnMyFeet, once you have Fitbit running"
        notification.alertAction = "get back to OnMyFeet"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func summariesDataDidSaved(_ dataType: String, startDate: String, endDate: String) {

    }
    
    //MARK: Motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            switch categories.count {
                case 4:
                    categories = ["My Goals", "Monitoring Progress", "Checking in", "Taking Action", "Developer"]
                case 5:
                    categories = ["My Goals", "Monitoring Progress", "Checking in", "Taking Action"]
                default:
                    break
            }
            self.menuTableView.reloadData()
        }
    }
    
}

