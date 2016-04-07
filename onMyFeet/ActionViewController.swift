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
    var alarmList:[Alarm]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Action"

        actionTableView.delegate = self
        actionTableView.dataSource = self
        actionTableView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.00)
        actionTableView.registerNib(UINib(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        getAlarmsFromDataBase()
        self.actionTableView.reloadData()
    }
    
    func getAlarmsFromDataBase() {
        let allAlarms = ClientDataManager.sharedInstance().fetchAllDataFor("Alarm") as? [Alarm]
        if let allAlarms = allAlarms {
            self.alarmList = allAlarms
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if let alarmList = alarmList {
                return alarmList.count
            } else {
                return 0
            }
        default:
            return 1
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
            return 88
        }
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 55
        default:
            return 45
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
                if let alarmList = alarmList {
                    let alarm = alarmList[indexPath.row]
                    let time = alarm.time!
                    alarmCell.alarmTime.text = time.substringToIndex(time.startIndex.advancedBy(5))
                    alarmCell.alarmSwitch.on = (alarm.on?.boolValue)!
                    alarmCell.alarmLabel.text = alarm.label
                    alarmCell.alarmId = alarm.id
                }
                
                return alarmCell
            case 2:
                cell?.textLabel?.text = "Set a New Alarm"
                cell?.textLabel?.textColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
            case 3:
                cell?.textLabel?.text = "Sync Alarm From Fitbit"
                cell?.textLabel?.textColor = UIColor.blackColor()
            default:
                cell?.textLabel?.text = "Error"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            let desController = NewAlarmController()
            desController.displayAlarm = alarmList![indexPath.row]
            self.navigationController?.pushViewController(desController, animated: true)
        case 2:
            let desController = NewAlarmController()
            let navb = UINavigationController(rootViewController: desController)
            self.presentViewController(navb, animated: true, completion: nil)
        case 3:
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                ClientDataManager.sharedInstance().deleteAllDataFor("Alarm")
                self.alarmList = nil
                FitbitAPI.sharedAPI().getAllAlarm()
                self.getAlarmsFromDataBase()
                dispatch_async(dispatch_get_main_queue()) {
                    self.actionTableView.reloadData()
                }
            }
        default:
            break
        }
        
        actionTableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
}
