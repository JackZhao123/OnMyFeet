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

@objc class NewAlarmController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepeatViewControllerDelegate, AlarmLabelViewControllerDelegate {
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        if displayAlarm == nil {
            self.title = "New Alarm"
            let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel as (Void) -> Void))
            cancelBtn.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = cancelBtn
        } else {
            self.title = "Edit"
        }
        
        let saveBtn = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save as (Void) -> Void))
        saveBtn.tintColor = UIColor.white
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
//        if let _ = displayAlarm {
//            if let displayAlarm = displayAlarm {
//                let id = displayAlarm.id
//                let alarmList = ClientDataManager.sharedInstance().fetchDataOf("Alarm", parameter: ["id"], argument: [id!]) as! [Alarm]
//                
//                let timeCell = mTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TimePickerCell
//                let labelCell = mTableView.cellForRow(at: IndexPath(row: 0, section: 2))
//                
//                let time = timeCell.getCurrentDisplayTime()
//                //            let fitbitId = NSUserDefaults.standardUserDefaults().valueForKey(Constants.UserDefaultsKey.FitbitID) as? String
//                
//                for a in alarmList {
//                    a.id = id
//                    a.time = time
//                    a.label = labelCell?.detailTextLabel?.text
//                    if repeatArray == nil {
//                        repeatArray = [String]()
//                    }
//                    a.period = ArrayDataConverter.stringArrayToNSData(repeatArray!)
//                    
//                }
//                ClientDataManager.sharedInstance().saveContext()
//                
//                
//            }
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            let timeIndex = IndexPath(row: 0, section: 0)
//            let timeCell = mTableView.cellForRow(at: timeIndex) as! TimePickerCell
//            timeCell.getCurrentDisplayTime()
//            let time = timeCell.getCurrentDisplayTime()
//            let id = UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.FitbitID) as? String
//            
//            if let id = id {
//                var recurring = false
//                var weekDays = [String]()
//                if let repeatArray = repeatArray {
//                    weekDays = repeatArray
//                    recurring = true
//                }
//                
//                let parameters:[String:AnyObject] = ["time":time as AnyObject, "enabled":true as AnyObject, "recurring":recurring as AnyObject, "weekDays": weekDays as AnyObject]
//                
//            }
//        }
    }
    
    //MARK: Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = displayAlarm {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0:
            return 220
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TimePickerCell", owner: self, options: nil)?.first as! TimePickerCell
        
        if let displayAlarm = displayAlarm {
            let time = displayAlarm.time!
            let t = time.substring(to: time.characters.index(time.startIndex, offsetBy: 5))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let date = formatter.date(from: t)
            cell.mTimePicker.date = date!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 1:
            let desController = RepeatViewController()
            desController.initArray = repeatArray
            desController.delegate = self
            self.navigationController?.pushViewController(desController, animated: true)
        case 2:
            let desController = AlarmLabelViewController()
            let cell = mTableView.cellForRow(at: indexPath)
            desController.delegate = self
            desController.initText = cell?.detailTextLabel?.text
            self.navigationController?.pushViewController(desController, animated: true)
        case 3:
            
            if let id = displayAlarm?.id {
                
            }
            _ = self.navigationController?.popViewController(animated: true)
        default:
            break
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    //MARK: Delegate
    func didPopUp(_ weekDay: [String]) {
        let index = IndexPath(row: 0, section: 1)
        let cell = mTableView.cellForRow(at: index)
        var repeatStr = ""

        if weekDay.count > 0 {
            repeatArray = weekDay
            if weekDay.count == 7 {
                repeatStr = "Every day"
            } else {
                for i in 0..<weekDay.count {
                    let s = weekDay[i].capitalized
                    let str = s.substring(to: s.characters.index(s.startIndex, offsetBy: 3))
                    repeatStr += " \(str)"
                }
            }
        } else {
            repeatArray = nil
            repeatStr = "Never"
        }
        cell?.detailTextLabel?.text = repeatStr
    }
    
    func labelViewDidPopUp(_ labelText: String?) {
        let index = IndexPath(row: 0, section: 2)
        let cell = mTableView.cellForRow(at: index)
        
        if labelText == "" {
            cell?.detailTextLabel?.text = "Alarm"
            self.labelText = "Alarm"
        } else {
            cell?.detailTextLabel?.text = labelText
            self.labelText = labelText!
        }
        
    }

}
