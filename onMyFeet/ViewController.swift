//
//  ViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-15.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DataCoordinatorDelegate {
//    MARK: Outlet
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var indicatiorView: UIView!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    
//    MARK: Properties
    var userInfo: String!
    var categories = ["My Goals", "Monitoring Progress", "Checking in", "Taking Action"]
    var refreshControl: UIRefreshControl!
    var coordinator: DataCoordinator = DataCoordinator()
    
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
        
        coordinator.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
        cell.categoryName.text = categories[indexPath.row]
        if indexPath.row == 4 {
            
            cell.categoryName.textColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tableViewHeight = self.menuTableView.frame.height - 64;
        return (tableViewHeight / (CGFloat)(categories.count));
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyboardIdentifier: String?
        switch indexPath.row {
        case 0:
            storyboardIdentifier = "ViewGoalsViewController"
        case 1:
            storyboardIdentifier = "ProgressController"
        case 2:
            storyboardIdentifier = "CheckIn"
        case 3:
            storyboardIdentifier = "Action"
        case 4:
            storyboardIdentifier = "TestModule"
        default:
            storyboardIdentifier = nil
        }
        
        if let storyboardIdentifier = storyboardIdentifier {
            let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
            self.navigationController!.pushViewController(desController, animated: true)
        }
        
        menuTableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    //MARK: Indicator
    func showIndicator() {
        mIndicator.startAnimating()
        indicatiorView.hidden = false
    }
    
    func hideIndicator() {
        indicatiorView.hidden = true
        mIndicator.stopAnimating()
    }
    //MARK: Actions

    @IBAction func logOut(sender: AnyObject) {
        
        let finishAlertController = UIAlertController(title: "Successfully Deleted All Goals and Activities", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {
            (okAction) in
            finishAlertController.dismissViewControllerAnimated(true, completion: nil)
        })
        finishAlertController.addAction(okAction)
        
        let resetAlertController = UIAlertController(title: "Reset All Data", message: "This operation could not be undo", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(cancelAction) in
            resetAlertController.dismissViewControllerAnimated(true, completion: nil)
        })
        let resetDataAction = UIAlertAction(title: "Reset All Goals and Activities", style: .Destructive, handler: {
            (resetDataAction) in
            Goal.MR_truncateAll()
            Activity.MR_truncateAll()
            ActivityProgress.MR_truncateAll()
            self.presentViewController(finishAlertController, animated: true, completion: nil)
        })
        
        resetAlertController.addAction(cancelAction)
        resetAlertController.addAction(resetDataAction)
        self.presentViewController(resetAlertController, animated: true, completion: nil)
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
    
    @IBAction func syncData(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "fitbit://")!)
        self.scheduleLocal(self)
    }
    
    func refresh() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {            
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func scheduleLocal(sender: AnyObject) {
        let setting = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if setting?.types == .None {
            let ac = UIAlertController(title: "Can't Schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = "Get back to OnMyFeet, once you have Fitbit running"
        notification.alertAction = "get back to OnMyFeet"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func summariesDataDidSaved(dataType: String, startDate: String, endDate: String) {
        if Constants.develop.ifGetStepDistance {
            switch dataType {
            case "steps":
                BackendOperation.sendStepData(startDate, end: endDate)
            case "distance":
                BackendOperation.sendDistanceData(startDate, end: endDate)
            case "StepDistance":
                BackendOperation.sendDistanceData(startDate, end: endDate)
                BackendOperation.sendStepData(startDate, end: endDate)
            default:
                break
            }
        }

    }
    
    //MARK: Motion
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            
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

