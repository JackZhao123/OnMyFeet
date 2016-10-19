//
//  RepeatViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
protocol RepeatViewControllerDelegate {
    func didPopUp(_ weekDay:[String])
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = delegate {
            var repeatArray = [String]()
            for i in 0..<7 {
                let index = IndexPath(row: i, section: 0)
                let cell = mTableView.cellForRow(at: index) as! RepeatCell
                if !cell.repeatImage.isHidden {
                    repeatArray.append(weekArray[i])
                }
            }
            delegate.didPopUp(repeatArray)
        }
    }
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RepeatCell", owner: self, options: nil)?.first as! RepeatCell
        
        if let initArray = initArray {
            if (initArray.index(of: weekArray[(indexPath as NSIndexPath).row]) != nil) {
                cell.repeatImage.isHidden = false
            }
        }
        
        let weekday = NSString(string: weekArray[(indexPath as NSIndexPath).row]).capitalized as String
        cell.repeatLabel?.text = "Every \(weekday)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = mTableView.cellForRow(at: indexPath) as! RepeatCell
        let hidden = cell.repeatImage.isHidden
        cell.repeatImage.isHidden = !hidden
        
        cell.isSelected = false
    }
}
