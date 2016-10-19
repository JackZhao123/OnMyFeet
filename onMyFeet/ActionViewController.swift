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
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var alarmList:[Alarm]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Action"

        actionTableView.delegate = self
        actionTableView.dataSource = self
        actionTableView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.00)
        actionTableView.register(UINib(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAlarmsFromDataBase()
        self.actionTableView.reloadData()
    }
    
    func getAlarmsFromDataBase() {
//        let allAlarms = ClientDataManager.sharedInstance().fetchAllDataFor("Alarm") as? [Alarm]
//        if let allAlarms = allAlarms {
//            self.alarmList = allAlarms
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 88
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 1:
            return 55
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let footer = UIView()
            let textView = UITextView(frame: CGRect(x: 8, y: 0.0, width: screenWidth - 16, height: 60))
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = UIColor.clear
            textView.text = "Wear your tracker to bed, and the alarm will use quiet vibrations to wake you. Or just use them to discreetly remind yourself to do things during the day"
            textView.textColor = UIColor(red: 0.651, green: 0.690, blue: 0.694, alpha: 1.00)
            textView.font = UIFont.systemFont(ofSize: 15.0)
            textView.sizeToFit()
            
            footer.addSubview(textView)
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actionTableView.dequeueReusableCell(withIdentifier: "ActionCell")
        switch (indexPath as NSIndexPath).section {
            case 0:
                cell?.textLabel?.text = "Relaxation"
                cell?.textLabel?.textColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
            case 1:
                let alarmCell = actionTableView.dequeueReusableCell(withIdentifier: "AlarmCell") as! AlarmCell
                if let alarmList = alarmList {
                    let alarm = alarmList[(indexPath as NSIndexPath).row]
                    let time = alarm.time!
                    alarmCell.alarmTime.text = time.substring(to: time.characters.index(time.startIndex, offsetBy: 5))
                    alarmCell.alarmSwitch.isOn = (alarm.on?.boolValue)!
                    alarmCell.alarmLabel.text = alarm.label
                    alarmCell.alarmId = alarm.id
                }
                
                return alarmCell
            case 2:
                cell?.textLabel?.text = "Set a New Alarm"
                cell?.textLabel?.textColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
            case 3:
                cell?.textLabel?.text = "Sync Alarm From Fitbit"
                cell?.textLabel?.textColor = UIColor.black
            default:
                cell?.textLabel?.text = "Error"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 1:
            let desController = NewAlarmController()
            desController.displayAlarm = alarmList![(indexPath as NSIndexPath).row]
            self.navigationController?.pushViewController(desController, animated: true)
        case 2:
            let desController = NewAlarmController()
            let navb = UINavigationController(rootViewController: desController)
            self.present(navb, animated: true, completion: nil)
        case 3:
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                self.alarmList = nil
                self.getAlarmsFromDataBase()
                DispatchQueue.main.async {
                    self.actionTableView.reloadData()
                }
            }
        default:
            break
        }
        
        actionTableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
}
