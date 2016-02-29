//
//  ViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-15.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.menuTableView.addSubview(refreshControl)
        
        indicatiorView.layer.cornerRadius = 8.0
        indicatiorView.clipsToBounds = true
        hideIndicator()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: (139/255.0), green: (195/255.0), blue: (74/255.0), alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("RefreshCode") as? String {
            self.userInfo = info
        } else {
            let logInController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as! LogInViewController
            self.presentViewController(logInController, animated: false, completion: nil)
        }
        
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
            storyboardIdentifier = "GoalsController"
        case 1:
            storyboardIdentifier = "ProgressController"
        default:
            storyboardIdentifier = nil
        }
        
        if let storyboardIdentifier = storyboardIdentifier {
            let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
            self.navigationController!.pushViewController(desController, animated: true)
        }
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
        let alertView = UIAlertController(title: "Logging Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {(action) in
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("RefreshCode")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LogOutManually")
            
            let logInController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogIn") as! LogInViewController
            self.presentViewController(logInController, animated: true, completion: nil)
            
        }))
        
        alertView.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {(action) in
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func syncData(sender: AnyObject) {
        
        self.refreshControl.beginRefreshing()
        menuTableView.setContentOffset(CGPoint(x: 0.0, y: -(self.refreshControl.frame.size.height)), animated: true)
        refresh()
    }
    
    func refresh() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Syncing")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            DataCoordinator.sharedInstance.syncData()
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            }
        }

    }
    
}

