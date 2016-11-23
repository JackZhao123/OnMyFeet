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
    var footerDoneView: UIView!
    var footerAddView: UIView!
    var separatorView: UIView!
    var customActivitiesList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        goals = Goal.MR_findAll() as! [Goal]
//        theGoal = goals[index]
        
        //        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseActivitiesTableViewController.goBack))
        //        backBtn.tintColor = UIColor.whiteColor()
        //        navigationItem.leftBarButtonItem = backBtn
        
//        let nextBtn = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChooseActivitiesTableViewController.done))
//        nextBtn.tintColor = UIColor.white
//        navigationItem.rightBarButtonItem = nextBtn
        
        footerAddView = UIView(frame: CGRect(x: 0, y: DisplayConstant.screenHeight() - 50, width: DisplayConstant.screenWidth()/2, height: 50))
        footerAddView.backgroundColor = UIColor.defaultGreenColor()
        
        let addLabel = UILabel(frame: CGRect(x: 0, y: 0, width: footerAddView.width, height: footerAddView.height))
        addLabel.text = "Add Others"
        addLabel.textColor = UIColor.white
        addLabel.font = UIFont.boldSystemFont(ofSize: 23)
        addLabel.textAlignment = .center
        footerAddView.addSubview(addLabel)
        
        let tapAddGesture = UITapGestureRecognizer(target: self, action: #selector(self.setPersonalActivity))
        tapAddGesture.numberOfTapsRequired = 1
        footerAddView.addGestureRecognizer(tapAddGesture)
        
        footerDoneView = UIView(frame: CGRect(x: footerAddView.right, y: DisplayConstant.screenHeight() - 50, width: DisplayConstant.screenWidth()/2, height: 50))
        footerDoneView.backgroundColor = UIColor.defaultGreenColor()
        
        let doneLabel = UILabel(frame: CGRect(x: 0, y: 0, width: footerDoneView.width, height: footerDoneView.height))
        doneLabel.text = "Done"
        doneLabel.textColor = UIColor.white
        doneLabel.font = UIFont.boldSystemFont(ofSize: 23)
        doneLabel.textAlignment = .center
        footerDoneView.addSubview(doneLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doneBtnTapped))
        tapGesture.numberOfTapsRequired = 1
        footerDoneView.addGestureRecognizer(tapGesture)
        
        let separatorWidth: CGFloat = 1.00
        separatorView = UIView(frame: CGRect(x: footerAddView.right - separatorWidth/2, y: footerAddView.top, width: separatorWidth, height: footerAddView.height))
        separatorView.backgroundColor = UIColor.white
        
        AppDelegate.shared().window?.addSubview(footerDoneView)
        AppDelegate.shared().window?.addSubview(footerAddView)
        AppDelegate.shared().window?.addSubview(separatorView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        footerDoneView.removeFromSuperview()
        footerAddView.removeFromSuperview()
        separatorView.removeFromSuperview()
        // Save when user navigate back to last VC
        self.save()
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
            return customActivitiesList.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseActivitiesTableViewCell", for: indexPath) as! ChooseActivitiesTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.label.text = physicalActs[(indexPath as NSIndexPath).row]
        case 1:
            cell.label.text = occupationalActs[(indexPath as NSIndexPath).row]
        case 2:
            cell.label.text = customActivitiesList[indexPath.row]
        default:
            cell.label.text = "Other"
        }
        
        if self.selectedIndexes.index(of: indexPath) == nil && indexPath.section != 2 {
            cell.checkView.isHidden = true
        }
        else
        {
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
//            headerCell.button.isHidden = false
//            headerCell.label.isHidden = true
//            headerCell.button.addTarget(self, action: #selector(ChooseActivitiesTableViewController.setPersonalActivity), for: .touchUpInside)
            headerCell.button.isHidden = true
            headerCell.label.text = "Custom Activities"
            headerCell.backgroundColor = UIColor(red: 0.949, green: 0.902, blue: 0.996, alpha: 1.00)
        default:
            headerCell.label.text = "Others"
        }
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 2) {
            return 50
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView (frame: CGRect (x: 0, y: 0, width: tableView.width, height: 40))
//        footerView.backgroundColor = UIColor.white
//        let doneBtn = UIButton (frame: CGRect (x: tableView.width/2-50, y: 5, width: 100, height: 30))
//        doneBtn.setTitle("Done", for: .normal)
//        doneBtn.setTitleColor(UIColor.white, for: .normal)
//        doneBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
//        doneBtn.titleLabel?.textAlignment = .center
//        doneBtn.backgroundColor = UIColor.defaultGreenColor()
//        doneBtn.layer.cornerRadius = 3.0
//        doneBtn.clipsToBounds = true
//        doneBtn.addTarget(self, action: #selector(ChooseActivitiesTableViewController.done), for: .touchUpInside)
//        footerView.addSubview(doneBtn)
        
        return nil
    }
    

    func setPersonalActivity() {
        let setAct = UIAlertController(title: "Add another therapy activity that you want to work on", message: "", preferredStyle: .alert)
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        setAct.addTextField { (textField) -> Void in
            textField.placeholder = "Enter your personal activity here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:{ (action) -> Void in
            let theName = setAct.textFields![0].text
            
            self.customActivitiesList.append(theName!)
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.customActivitiesList.count - 1, section: 2)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
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
    
    func doneBtnTapped() {
        save()
        goBack()
    }
    
    func save() {
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
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
