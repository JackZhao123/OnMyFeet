//
//  NewAlarmController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
protocol NewAlarmDelegate {
    func newAlarmDidDismissed()
}

@objc class NewAlarmController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepeatViewControllerDelegate, AlarmLabelViewControllerDelegate, FitbitAPIDelegate {
    @IBOutlet weak var mTableView: UITableView!
    
    var timeString: String?
    var period: [Int]?
    
    var repeatArray: [String]?
    var labelText = "Alarm"
    var delegate:NewAlarmDelegate?
    var displayAlarm: Alarm?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        if displayAlarm == nil {
            self.title = "New Alarm"
            let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancel as Void -> Void))
            cancelBtn.tintColor = UIColor.whiteColor()
            navigationItem.leftBarButtonItem = cancelBtn
        } else {
            self.title = "Edit"
        }
        
        let saveBtn = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(save as Void -> Void))
        saveBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = saveBtn
        
        self.automaticallyAdjustsScrollViewInsets = false
        mTableView.delegate = self
        mTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        if let _ = displayAlarm {
            if let displayAlarm = displayAlarm {
                let id = displayAlarm.id
                let alarmList = ClientDataManager.sharedInstance().fetchDataOf("Alarm", parameter: ["id"], argument: [id!]) as! [Alarm]
                
                let timeCell = mTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TimePickerCell
                let labelCell = mTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
                
                let time = timeCell.getCurrentDisplayTime()
                //            let fitbitId = NSUserDefaults.standardUserDefaults().valueForKey(Constants.UserDefaultsKey.FitbitID) as? String
                
                for a in alarmList {
                    a.id = id
                    a.time = time
                    a.label = labelCell?.detailTextLabel?.text
                    if repeatArray == nil {
                        repeatArray = [String]()
                    }
                    a.period = ArrayDataConverter.stringArrayToNSData(repeatArray!)
                    
                    FitbitAPI.sharedAPI().updateAlarmFor(a.id!, alarm: a)
                }
                ClientDataManager.sharedInstance().saveContext()
                
                
            }
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let timeIndex = NSIndexPath(forRow: 0, inSection: 0)
            let timeCell = mTableView.cellForRowAtIndexPath(timeIndex) as! TimePickerCell
            timeCell.getCurrentDisplayTime()
            let time = timeCell.getCurrentDisplayTime()
            let id = NSUserDefaults.standardUserDefaults().valueForKey(Constants.UserDefaultsKey.FitbitID) as? String
            
            if let id = id {
                var recurring = false
                var weekDays = [String]()
                if let repeatArray = repeatArray {
                    weekDays = repeatArray
                    recurring = true
                }
                
                let parameters:[String:AnyObject] = ["time":time, "enabled":true, "recurring":recurring, "weekDays": weekDays]
                
                let fitbitAPI = FitbitAPI()
                fitbitAPI.delegate = self
                
                fitbitAPI.addAlarm(parameters, id: id)
            }
        }
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _ = displayAlarm {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 220
        default:
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = NSBundle.mainBundle().loadNibNamed("TimePickerCell", owner: self, options: nil).first as! TimePickerCell
            
            if let displayAlarm = displayAlarm {
                let time = displayAlarm.time!
                let t = time.substringToIndex(time.startIndex.advancedBy(5))
                let formatter = NSDateFormatter()
                formatter.dateFormat = "HH:mm"
                let date = formatter.dateFromString(t)
                cell.mTimePicker.date = date!
            }
            
            return cell
        } else {
            var cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.detailTextLabel?.textColor = UIColor.grayColor()

            switch indexPath.section {
            case 1:
                cell.textLabel?.text = "Repeat"
                cell.detailTextLabel?.text = "Never"
                if let displayAlarm = displayAlarm {
                    if let period = displayAlarm.period {
                        let data = period
                        let repeatString = ArrayDataConverter.nsDataToStringArray(data)
                        
                        var repeatStr = ""
                        
                        if repeatString.count > 0 {
                            repeatArray = repeatString
                            if repeatString.count == 7 {
                                repeatStr = "Every day"
                            } else {
                                for i in 0..<repeatString.count {
                                    let s = repeatString[i].capitalizedString
                                    let str = s.substringToIndex(s.startIndex.advancedBy(3))
                                    repeatStr += " \(str)"
                                }
                            }
                        } else {
                            repeatArray = nil
                            repeatStr = "Never"
                        }
                        
                        cell.detailTextLabel?.text = repeatStr
                    }
                }
                
            case 2:
                cell.textLabel?.text = "Label"
                cell.detailTextLabel?.text = "Alarm"
                if let displayAlarm = displayAlarm {
                    cell.detailTextLabel?.text = displayAlarm.label
                }
                
            case 3:
                cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                cell.textLabel?.text = "Delete Alarm"
                cell.textLabel?.textAlignment = .Center
                cell.textLabel?.textColor = UIColor.redColor()
            default:
                cell.textLabel?.text = "Error"
                cell.detailTextLabel?.text = "Error"
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 1:
            let desController = RepeatViewController()
            desController.initArray = repeatArray
            desController.delegate = self
            self.navigationController?.pushViewController(desController, animated: true)
        case 2:
            let desController = AlarmLabelViewController()
            let cell = mTableView.cellForRowAtIndexPath(indexPath)
            desController.delegate = self
            desController.initText = cell?.detailTextLabel?.text
            self.navigationController?.pushViewController(desController, animated: true)
        case 3:
            
            if let id = displayAlarm?.id {
                
                ClientDataManager.sharedInstance().deleteDataFor("Alarm", parameter: ["id"], argument: [id])
                FitbitAPI.sharedAPI().deleteAlarmFor(id)
            }
            self.navigationController?.popViewControllerAnimated(true)
        default:
            break
        }
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    //MARK: Delegate
    func didPopUp(weekDay: [String]) {
        let index = NSIndexPath(forRow: 0, inSection: 1)
        let cell = mTableView.cellForRowAtIndexPath(index)
        var repeatStr = ""

        if weekDay.count > 0 {
            repeatArray = weekDay
            if weekDay.count == 7 {
                repeatStr = "Every day"
            } else {
                for i in 0..<weekDay.count {
                    let s = weekDay[i].capitalizedString
                    let str = s.substringToIndex(s.startIndex.advancedBy(3))
                    repeatStr += " \(str)"
                }
            }
        } else {
            repeatArray = nil
            repeatStr = "Never"
        }
        cell?.detailTextLabel?.text = repeatStr
    }
    
    func labelViewDidPopUp(labelText: String?) {
        let index = NSIndexPath(forRow: 0, inSection: 2)
        let cell = mTableView.cellForRowAtIndexPath(index)
        
        if labelText == "" {
            cell?.detailTextLabel?.text = "Alarm"
            self.labelText = "Alarm"
        } else {
            cell?.detailTextLabel?.text = labelText
            self.labelText = labelText!
        }
        
    }
    
    //MARK: Fitbit Delegate
    func alarmDidSet(data: NSData) {
        let json = JSON(data: data)
        let time = json["trackerAlarm"]["time"].stringValue
        let id = json["trackerAlarm"]["alarmId"].stringValue
        var period = [String]()
        
        for i in 0..<json["trackerAlarm"]["weekDays"].count {
            period.append(json["trackerAlarm"]["weekDays"][i].stringValue)
        }
        
        if repeatArray == nil {
            repeatArray = ["Never"]
        }
        
        if time != "" {
            let alarm = Alarm()
            alarm.on = true
            alarm.id = id
            alarm.time = time
            alarm.label = labelText
            if period.count > 0 {
                alarm.period = ArrayDataConverter.stringArrayToNSData(repeatArray!)
            }
            ClientDataManager.sharedInstance().saveContext()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
