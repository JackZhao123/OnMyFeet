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
    
//    MARK: Properties
    var userInfo: String!
    var categories = ["My Goals", "Monitoring Progress", "Checking in", "Taking Action"]
    
//    MARK: view initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
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
        DataCoordinator.sharedInstance.syncData()
    }
    
}

