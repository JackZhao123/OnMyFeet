//
//  NewAlarmController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class NewAlarmController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mToolBar: UIToolbar!
    @IBOutlet weak var mTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
        navigationController?.title = "New Alarm"
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancel as Void -> Void))
        cancelBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = cancelBtn
        
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
        print("save")
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
            return cell
        } else {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.detailTextLabel?.textColor = UIColor.grayColor()

            switch indexPath.section {
            case 1:
                cell.textLabel?.text = "Repeat"
                cell.detailTextLabel?.text = "Never"
            case 2:
                cell.textLabel?.text = "Label"
                cell.detailTextLabel?.text = "Alarm"
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
            self.navigationController?.pushViewController(desController, animated: true)
        case 2:
            let desController = AlarmLabelViewController()
            self.navigationController?.pushViewController(desController, animated: true)
        default:
            break
        }
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }

}
