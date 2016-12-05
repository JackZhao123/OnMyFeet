//
//  ViewActivitiesViewController.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ViewActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewActivitesTableViewCellDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var rainbowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var theLine: LineChart!
    @IBOutlet weak var theSlider: GradientSlider!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var actLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var setStatusBtn: UIButton!
    @IBOutlet weak var viewProgressBtn: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    
    var goals = [Goal]()
    var theGoal: Goal?
    var theActivity: Activity?
    var relations: NSMutableSet = []
    var progressRelations: NSMutableSet = []
    var flag = false
    var theStatus: Float = 0.0
    var theName: String = ""
    var headerView: UIView?
    var footerView: UIView?
    var isWeeklyGraphShowing = false
    
    var goalDescriptionLabel: UILabel!
    var personalizedAlertController: UIAlertController!
    
    //MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.delegate = self
        activityTable.dataSource = self
        
        relations = (theGoal!.mutableSetValue(forKey: "activities"))
        
        self.title = "My Activities"
        
        rainbowView.isHidden = true

        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewActivitiesViewController.goHome))
        homeBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = homeBtn
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        doneBtn.layer.cornerRadius = 5.0;
        doneBtn.layer.borderColor = UIColor.gray.cgColor
        doneBtn.layer.borderWidth = 1.5
        //dailyView.layer.cornerRadius = 10.0
        greenView.layer.cornerRadius = 10.0
        //redView.layer.cornerRadius = 10.0
        
        //setStatusBtn.layer.cornerRadius = 5.0
        setStatusBtn.layer.borderColor = UIColor.gray.cgColor
        setStatusBtn.layer.borderWidth = 1.5
        
        //viewProgressBtn.layer.cornerRadius = 5.0
        viewProgressBtn.layer.borderColor = UIColor.gray.cgColor
        viewProgressBtn.layer.borderWidth = 1.5
        
        let buttonHeight: CGFloat = 45
        
        let deleteBtn = UIButton(frame: CGRect(x: 0, y: self.view.height - buttonHeight - 64, width: self.view.width, height: buttonHeight))
        deleteBtn.setTitle("Delete Goal", for: .normal)
        deleteBtn.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.00)
        deleteBtn.addTarget(self, action: #selector(self.deleteGoal), for: .touchUpInside)
        self.view.addSubview(deleteBtn)
        
        let addActBtn = UIButton(frame: CGRect(x: 0, y: deleteBtn.top - 7 - buttonHeight, width: self.view.width, height: buttonHeight))
        addActBtn.setTitle("Tap here to add therapy activities", for: .normal)
        addActBtn.backgroundColor = UIColor.defaultGreenColor()
        addActBtn.addTarget(self, action: #selector(self.goNext), for: .touchUpInside)
        self.view.addSubview(addActBtn)
        
        let headerV = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 235))
        
        let actImageView = UIImageView(frame: CGRect(x: (headerV.width - 200) / 2, y: 15, width: 200, height: 150))
        actImageView.image = UIImage(data: theGoal!.picture! as Data)
        headerV.addSubview(actImageView)
        
        goalDescriptionLabel = UILabel(frame: CGRect(x: 20, y: actImageView.bottom + 10, width: (headerV.width - 40), height: 50))
        if theGoal!.answer == nil || theGoal!.answer == "" {
            goalDescriptionLabel.text = "Please tap here to personalize your goal"
            goalDescriptionLabel.textColor = UIColor.gray
        } else {
            goalDescriptionLabel.text = theGoal!.answer
            goalDescriptionLabel.textColor = UIColor.black
        }
        goalDescriptionLabel.numberOfLines = 0
        goalDescriptionLabel.backgroundColor = UIColor(red: 0.820, green: 0.945, blue: 0.820, alpha: 1.00)
        goalDescriptionLabel.textAlignment = .center
        goalDescriptionLabel.sizeToFit()
        goalDescriptionLabel.setWidth(value: (headerV.width - 40))
        goalDescriptionLabel.setHeight(value: goalDescriptionLabel.height + 10)
        goalDescriptionLabel.isUserInteractionEnabled = true
        headerV.addSubview(goalDescriptionLabel)
        
        let descriptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.descriptionLabelTapped))
        goalDescriptionLabel.addGestureRecognizer(descriptionTapGesture)
        
        
        headerV.setHeight(value: (actImageView.height + goalDescriptionLabel.height + 10 + 15 + 10))
        activityTable.tableHeaderView = headerV
        
        personalizedAlertController = UIAlertController(title: nil, message: "Please enter your personalized goal", preferredStyle: .alert)
        personalizedAlertController.addTextField(configurationHandler: {(textField) in
            textField.delegate = self
            if self.theGoal!.answer == nil || self.theGoal!.answer == "" {
                textField.placeholder = "Personlize your goal"
            } else {
                textField.placeholder = self.theGoal!.answer
            }
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            if let text = self.personalizedAlertController.textFields?.first?.text, text != ""{
                self.theGoal?.answer = text
                self.goalDescriptionLabel.text = text
                self.personalizedAlertController.textFields?.first?.placeholder = text
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            }
            
            self.personalizedAlertController.textFields?.first?.text = ""
            

        })
        okAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            self.personalizedAlertController.textFields?.first?.text = ""
        })
        
        personalizedAlertController.addAction(okAction)
        personalizedAlertController.addAction(cancelAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        relations = (theGoal!.mutableSetValue(forKey: "activities"))
        activityTable.reloadData()
    }
    
    //MARK: Activities, Goals and Status
    
    func saveStatus(_ slider: GradientSlider, indexPath: IndexPath) {
        var status: Float = 0.0
        var name: String = ""
        slider.endBlock = {slider, newValue, newLocation in
            let theRelate = self.relations.allObjects[(indexPath as NSIndexPath).row] as! Activity
            name = theRelate.name
            status = Float(newValue)
            self.changeStatus(name, status: status)
        }
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components ([.day, .month, .year], from: date)
        
        let year = String(describing: components.year!)
        let month = String(format: "%02d", components.month!)
        let day = String(format: "%02d", components.day!)
        
        let theDate = (year + month + day)
        return theDate
    }
    
    func changeStatus(_ name: String, status: Float) {
        let predicate = NSPredicate(format: "name == %@", name)
        var theActivity = Activity.mr_findFirst(with: predicate)
        if theActivity == nil {
            theActivity = Activity.mr_createEntity()
        }
        
        guard let activity = theActivity else {
            return
        }
        
        activity.name = name
        activity.status = status
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        let date = getDate()
        
        let results = ActivityProgress.mr_findAllSorted(by: "date", ascending: true, with: NSPredicate(format: "activity.name == %@ AND date == %@", activity.name, date), in: NSManagedObjectContext.mr_default())
        
        guard let allProgress = results as? [ActivityProgress] else {
            return
        }
        
        print("pay attention here!!!!!!!!!!" + String(theStatus))
        
        if (allProgress.count == 0) {
            let progress = ActivityProgress.mr_createEntity()
            
            guard let newProgress = progress else {
                return
            }
            
            var progressActRelate = NSMutableSet()
            
            newProgress.date = date
            newProgress.status = status
            
            progressActRelate = activity.mutableSetValue(forKey: "activityProgresses")
            progressActRelate.add(newProgress)
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
        else {
            allProgress[0].status = status
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
        
        setLableText(name)
    }
    
    func deleteActivityAt(idx: IndexPath) {
        let theRelate = relations.allObjects[(idx as NSIndexPath).row] as! Activity
        let theName = theRelate.name
        
        let deletingAlertController = UIAlertController(title: "Deleting Activity \n\"\(theName)\"", message: "Are you sure you want to delete the activity \"\(theName)\"", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default, handler: {(action) in
            deletingAlertController.dismiss(animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) in
            let theActivity = Activity.mr_findFirst(with: NSPredicate(format: "name == %@", theName))
            
            if let activity = theActivity {
                self.relations.remove(activity)
                if (activity.mutableSetValue(forKey: "goals").count == 0) {
                    activity.mr_deleteEntity()
                }
                
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                
                DispatchQueue.main.async {
                    self.activityTable.deleteRows(at: [idx], with: .fade )
                    self.activityTable.reloadSections(IndexSet(integer: 0), with: .none)
                }
            }
            
            deletingAlertController.dismiss(animated: true, completion: nil)
        })
        
        deletingAlertController.addAction(noAction)
        deletingAlertController.addAction(deleteAction)
        self.present(deletingAlertController, animated: true, completion: nil)
    }
    
    func deleteGoal() {
        let deleteGoalAlertController = UIAlertController(title: "Deleting Goal", message: "Are you sure you want to delete the goal", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default, handler: {(action) in
            deleteGoalAlertController.dismiss(animated: true, completion: nil)
        })
        let deleteGoalAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) in
            
            DispatchQueue.main.async {
                let goal = Goal.mr_findFirst(with: NSPredicate(format: "answer == %@ AND question = %@", (self.theGoal?.answer!)!, (self.theGoal?.question)!))
                goal?.mr_deleteEntity()
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                deleteGoalAlertController.dismiss(animated: true, completion: nil)
                self.goBack()
            }
        })
        
        deleteGoalAlertController.addAction(noAction)
        deleteGoalAlertController.addAction(deleteGoalAction)
        self.present(deleteGoalAlertController, animated: true, completion: nil)
    }
    
    func setLableText(_ name: String) {
        
        var dates: [String] = ["", "", "", "", "", "", ""]
        var theDates: [String] = ["", "", "", "", "", "", ""]
        var graphPoints = [Int]()
        
        var theActivity = Activity.mr_findFirst(with: NSPredicate(format: "name == %@", theName))
        
        
        if theActivity == nil {
            theActivity = Activity.mr_createEntity()
            theActivity?.name = theName
            theActivity?.status = 0
        }
        
        guard let activity = theActivity else {
            return
        }
        
        progressRelations = activity.mutableSetValue(forKey: "activityProgresses")
        print(activity.name)
        print(activity.status)
        print(progressRelations)
        let theArray: NSArray = progressRelations.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as NSArray
        
        if progressRelations.count > 7 {
            for index in 0..<7 {
                let theRelate = theArray.object(at: progressRelations.count-(7-index)) as! ActivityProgress
                print(theRelate)
        
                dates[index] = theRelate.date
                
                theDates[index] = dates[index].substring(with: Range<String.Index> (dates[index].characters.index(dates[index].startIndex, offsetBy: 4)..<dates[index].characters.index(dates[index].endIndex, offsetBy: -2))) + "/" + dates[index].substring(with: Range<String.Index> (dates[index].characters.index(dates[index].endIndex, offsetBy: -2)..<dates[index].endIndex))
                
                graphPoints.append(Int(theRelate.status * 1000.0))
            }
        }
        else {
            for index in 0..<progressRelations.count {
                let theRelate = theArray.object(at: index) as! ActivityProgress
                dates[index] = theRelate.date
                print(dates[index])
                
                if (dates[index].characters.count != 0) {
                    theDates[index] = dates[index].substring(with: Range<String.Index> (dates[index].characters.index(dates[index].startIndex, offsetBy: 4)..<dates[index].characters.index(dates[index].endIndex, offsetBy: -2))) + "/" + dates[index].substring(with: Range<String.Index> (dates[index].characters.index(dates[index].endIndex, offsetBy: -2)..<dates[index].endIndex))
                }
                else {
                    theDates[index] = dates[index]
                }
                graphPoints.append(Int(theRelate.status * 1000.0))
                print(Int(theRelate.status * 1000.0))
            }
        }
        
        label1.text = theDates[0]
        label2.text = theDates[1]
        label3.text = theDates[2]
        label4.text = theDates[3]
        label5.text = theDates[4]
        label6.text = theDates[5]
        label7.text = theDates[6]
        theLine.thePoints = graphPoints
        theLine.setNeedsDisplay()
    }
    
    //MARK: User Interaction
    func descriptionLabelTapped() {
        
        personalizedAlertController.actions[0].isEnabled = false
        self.present(personalizedAlertController, animated: true, completion: nil)
    }
    
    @IBAction func setStatusClick(_ sender: AnyObject) {
        if (isWeeklyGraphShowing) {
            UIView.transition(from: weeklyView, to: dailyView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            isWeeklyGraphShowing = false
        }
    }
    
    @IBAction func viewProgressClick(_ sender: AnyObject) {
        if(!isWeeklyGraphShowing) {
            UIView.transition(from: dailyView, to: weeklyView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            isWeeklyGraphShowing = true
        }
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        rainbowView.isHidden = true
        activityTable.reloadData()
        UIView.transition(from: weeklyView, to: dailyView, duration: 0.0, options: .showHideTransitionViews, completion: nil)
        isWeeklyGraphShowing = false
    }
    
    func chooseSlider(_ slider: GradientSlider, status: CGFloat) {
        slider.actionBlock = {slider, newValue in
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            slider.thumbColor = UIColor(hue: newValue / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            CATransaction.commit()
        }
        slider.thumbColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goNext(){
        let storyboardIdentifier = "ChooseActivitiesTableViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! ChooseActivitiesTableViewController
        desController.theGoal = theGoal
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    //MARK: TableView Datasource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewActivitiesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as! ViewActivitiesTableViewCell
        
        let theRelate = relations.allObjects[(indexPath as NSIndexPath).row] as! Activity
        cell.currentIdx = indexPath
        cell.delegate = self
        
        let name = theRelate.name
        let status = CGFloat(theRelate.status)
        
        cell.label.text = name
        
        cell.status.backgroundColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        cell.status.layer.cornerRadius = 5.0
        cell.status.clipsToBounds = true
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rainbowView.isHidden = false
        
        let theRelate = relations.allObjects[(indexPath as NSIndexPath).row] as! Activity
        theName = theRelate.name
        theStatus = theRelate.status
        
        actLabel.text = theName
        theSlider.value = CGFloat(theStatus)
        theSlider.thumbColor = UIColor(hue: CGFloat(theStatus) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        chooseSlider(theSlider, status: CGFloat(theStatus))
        saveStatus(theSlider, indexPath: indexPath)
        setLableText(theName)
    }
    
    //MARK: ViewActivitesTableViewCellDelegate
    func deleteBtnDidTapped(_ idx: IndexPath) {
        self.deleteActivityAt(idx: idx)
    }
    
    //MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" && range.location == 0 {
            personalizedAlertController.actions[0].isEnabled = false
            
        } else {
            personalizedAlertController.actions[0].isEnabled = true
        }
        
        return true
    }
}
