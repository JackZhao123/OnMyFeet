//
//  ChooseActivitiesTableViewController.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ChooseActivitiesTableViewController: UITableViewController {
    
    var occupationalActs = ["Bath/Shower", "Carrying Groceries", "Dressing", "Eating", "Gathering Items", "Grooming", "Meal Preparation"]
    var physicalActs = ["Balance", "Bed Mobility", "Coordination", "Endurance", "Stairs", "Strengthening", "Transfers", "Walking"]
    
    var names = ["Balance", "Bed Mobility", "Coordination", "Endurance", "Stairs", "Strengthening", "Transfers", "Walking", "Bath/Shower", "Carrying Groceries", "Dressing", "Eating", "Gathering Items", "Grooming", "Meal Preparation"]
    
    var selectedIndexes = [IndexPath]() {
        didSet {
            tableView.reloadData()
        }
    }
    var theIndexes = [Int]()
    
//    var index: Int = 0
    var goals = [Goal]()
    var activities = [Activity]()
    var theGoal: Goal?
    var theActivity: Activity?
    var footerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        goals = Goal.MR_findAll() as! [Goal]
//        theGoal = goals[index]
        
        //        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseActivitiesTableViewController.goBack))
        //        backBtn.tintColor = UIColor.whiteColor()
        //        navigationItem.leftBarButtonItem = backBtn
        
//        let nextBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChooseActivitiesTableViewController.done))
//        nextBtn.tintColor = UIColor.white
//        navigationItem.rightBarButtonItem = nextBtn
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return physicalActs.count
        case 1:
            return occupationalActs.count
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseActivitiesTableViewCell", for: indexPath) as! ChooseActivitiesTableViewCell
        
        switch ((indexPath as NSIndexPath).section) {
        case 0:
            cell.label.text = physicalActs[(indexPath as NSIndexPath).row]
        case 1:
            cell.label.text = occupationalActs[(indexPath as NSIndexPath).row]
        default:
            cell.label.text = "Other"
        }
        
        if self.selectedIndexes.index(of: indexPath) == nil {
            cell.checkView.isHidden = true
        }
        else {
            cell.checkView.isHidden = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section) {
        case 0:
            if let indexSelected = selectedIndexes.index(of: indexPath) {
                selectedIndexes.remove(at: indexSelected)
                theIndexes.remove(at: indexSelected)
            }
            else {
                selectedIndexes.append(indexPath)
                theIndexes.append((indexPath as NSIndexPath).row)
            }
        case 1:
            if let indexSelected = selectedIndexes.index(of: indexPath) {
                selectedIndexes.remove(at: indexSelected)
                theIndexes.remove(at: indexSelected)
            }
            else {
                selectedIndexes.append(indexPath)
                theIndexes.append((indexPath as NSIndexPath).row + physicalActs.count)
            }
        default:
            if let indexSelected = selectedIndexes.index(of: indexPath) {
                selectedIndexes.remove(at: indexSelected)
            }
            else {
                selectedIndexes.append(indexPath)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        switch (section) {
        case 0:
            headerCell.button.isHidden = true
            headerCell.label.text = "Occupational Therapy Activities"
            headerCell.backgroundColor = UIColor (red: 248/255, green: 235/255, blue: 195/255, alpha: 0.95)
        case 1:
            headerCell.button.isHidden = true
            headerCell.label.text = "Physical Therapy Activities"
            headerCell.backgroundColor = UIColor (red: 234/255, green: 253/255, blue: 251/255, alpha: 0.95)
        case 2:
            headerCell.button.isHidden = false
            headerCell.label.isHidden = true
            headerCell.button.addTarget(self, action: #selector(ChooseActivitiesTableViewController.setPersonalActivity), for: .touchUpInside)

        default:
            headerCell.label.text = "Others"
        }
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 2) {
            return 40
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView (frame: CGRect (x: 0, y: 0, width: tableView.width, height: 40))
        footerView.backgroundColor = UIColor.white
        let doneBtn = UIButton (frame: CGRect (x: tableView.width/2-50, y: 5, width: 100, height: 30))
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(UIColor.white, for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        doneBtn.titleLabel?.textAlignment = .center
        doneBtn.backgroundColor = UIColor.defaultGreenColor()
        doneBtn.layer.cornerRadius = 3.0
        doneBtn.clipsToBounds = true
        doneBtn.addTarget(self, action: #selector(ChooseActivitiesTableViewController.done), for: .touchUpInside)
        footerView.addSubview(doneBtn)
        
        return footerView
    }
    

    func setPersonalActivity() {
        let setAct = UIAlertController(title: "Add a personal activity that is important to you", message: "", preferredStyle: .alert)
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        setAct.addTextField { (textField) -> Void in
            textField.placeholder = "Enter your personal activity here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:{ (action) -> Void in
            let theName = setAct.textFields![0].text
            
            let predicate = NSPredicate(format: "name == %@", theName!)
            self.theActivity = Activity.mr_findFirst(with: predicate)
            if(self.theActivity == nil) {
                self.theActivity = Activity.mr_createEntity()
                self.theActivity?.name = theName!
                self.theActivity?.status = 0
            }
            
            let actGoalRelation = self.theGoal?.mutableSetValue(forKey: "activities")
            actGoalRelation?.add(self.theActivity!)
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        })
        
        alert.addAction(cancelAction)
        setAct.addAction(saveAction)
        setAct.addAction(cancelAction)
        present(setAct, animated: true, completion: nil)
    }
    
    func done() {
        for index in 0..<theIndexes.count {
            let theIndex = theIndexes[index]
            let theName = names[theIndex]
            
            let predicate = NSPredicate(format: "name == %@", theName)
            theActivity = Activity.mr_findFirst(with: predicate)
            if theActivity == nil {
                theActivity = Activity.mr_createEntity()
                theActivity?.name = theName
                theActivity?.status = 0
            }
            
            let actGoalRelation = theGoal!.mutableSetValue(forKey: "activities")
            actGoalRelation.add(theActivity!)
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
        goBack()
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
