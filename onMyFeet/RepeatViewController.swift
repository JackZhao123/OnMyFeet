//
//  RepeatViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
protocol RepeatViewControllerDelegate {
    func didPopUp(weekDay:[String])
}

class RepeatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    
    let weekArray = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
    var delegate:RepeatViewControllerDelegate?
    var initArray:[String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let delegate = delegate {
            var repeatArray = [String]()
            for i in 0..<7 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                let cell = mTableView.cellForRowAtIndexPath(index) as! RepeatCell
                if !cell.repeatImage.hidden {
                    repeatArray.append(weekArray[i])
                }
            }
            delegate.didPopUp(repeatArray)
        }
    }
    
    //MARK: TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("RepeatCell", owner: self, options: nil).first as! RepeatCell
        
        if let initArray = initArray {
            if (initArray.indexOf(weekArray[indexPath.row]) != nil) {
                cell.repeatImage.hidden = false
            }
        }
        
        let weekday = NSString(string: weekArray[indexPath.row]).capitalizedString as String
        cell.repeatLabel?.text = "Every \(weekday)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = mTableView.cellForRowAtIndexPath(indexPath) as! RepeatCell
        let hidden = cell.repeatImage.hidden
        cell.repeatImage.hidden = !hidden
        
        cell.selected = false
    }
}
