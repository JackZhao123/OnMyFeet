//
//  ActionViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var actionTableView: UITableView!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Action"

        actionTableView.delegate = self
        actionTableView.dataSource = self
        actionTableView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.00)
        actionTableView.registerNib(UINib(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2:
            return 1
        default:
            return 3
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 40
        }
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0,2:
            return 45
        default:
            return 55
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let footer = UIView()
            let textView = UITextView(frame: CGRect(x: 8, y: 0.0, width: screenWidth - 16, height: 60))
            textView.userInteractionEnabled = false
            textView.backgroundColor = UIColor.clearColor()
            textView.text = "Wear your tracker to bed, and the alarm will use quiet vibrations to wake you. Or just use them to discreetly remind yourself to do things during the day"
            textView.textColor = UIColor(red: 0.651, green: 0.690, blue: 0.694, alpha: 1.00)
            textView.font = UIFont.systemFontOfSize(15.0)
            textView.sizeToFit()
            footer.addSubview(textView)
            return footer
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = actionTableView.dequeueReusableCellWithIdentifier("ActionCell")
        switch indexPath.section {
            case 0:
                cell?.textLabel?.text = "Relaxation"
                cell?.textLabel?.textColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
            case 1:
                let alarmCell = actionTableView.dequeueReusableCellWithIdentifier("AlarmCell") as! AlarmCell
                return alarmCell
            case 2:
                cell?.textLabel?.text = "Set a New Alarm"
                cell?.textLabel?.textColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
            default:
                cell?.textLabel?.text = "Error"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            let desController = NewAlarmController()
            let navb = UINavigationController(rootViewController: desController)
            self.presentViewController(navb, animated: true, completion: nil)
        }
        
        actionTableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
}
