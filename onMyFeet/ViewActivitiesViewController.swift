//
//  ViewActivitiesViewController.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ViewActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var RainbowView: UIView!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var DailyView: UIView!
    @IBOutlet weak var WeeklyView: UIView!
    @IBOutlet weak var theLine: LineChart!
    @IBOutlet weak var theSlider: GradientSlider!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var actLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    
//    var index: Int = 0
    var goals = [Goal]()
    var theGoal: Goal?
    var theActivity: Activity?
    var relations: NSMutableSet = []
    var progressRelations: NSMutableSet = []
    var flag = false
    var theStatus: Float = 0.0
    var theName: String = ""
    var footerView: UIView?
    var isWeeklyGraphShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.delegate = self
        activityTable.dataSource = self
        
        relations = (theGoal!.mutableSetValue(forKey: "activities"))
        
        self.title = "My Activities"
        
        show()
        
        RainbowView.isHidden = true
        stackView.isHidden = false
        textView.isHidden = false
        textView.delegate = self
        

        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewActivitiesViewController.goHome))
        homeBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = homeBtn
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        doneBtn.layer.cornerRadius = 5.0;
        doneBtn.layer.borderColor = UIColor.gray.cgColor
        doneBtn.layer.borderWidth = 1.5
        DailyView.layer.cornerRadius = 10.0
        greenView.layer.cornerRadius = 10.0
        redView.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        relations = (theGoal!.mutableSetValue(forKey: "activities"))
        activityTable.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        theGoal?.answer = textView.text
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func show() {
        imageView.image = UIImage(data: theGoal!.picture! as Data)
        textView.text = theGoal!.answer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewActivitiesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:  indexPath) as! ViewActivitiesTableViewCell
        
        let theRelate = relations.allObjects[(indexPath as NSIndexPath).row] as! Activity
        
        let name = theRelate.name
        let status = CGFloat(theRelate.status)
        

        
        
        cell.label.text = name
        
        cell.theSlider.thumbColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        cell.theSlider.value = status
        
        //chooseSlider(cell.theSlider, status: status)
        //getStatus(cell.theSlider)
        
        return cell
    }
    
    
//    func getStatus(slider: GradientSlider) {
//        var status: Float = 0.0
//        var name: String = ""
//        slider.endBlock = {slider, newValue, newLocation in
//            let point = newLocation
//            let pointInCell = slider.convertPoint(point, toView: self.activityTable)
//            let index = self.activityTable.indexPathForRowAtPoint(pointInCell)!.row
//            
//            status = Float(newValue)
//            name = String(self.relations.allObjects[index].valueForKey("name")!)
//            
//            self.changeStatus(name, status: status)
//        }
//    }
    
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
    
    
    func chooseSlider(_ slider: GradientSlider, status: CGFloat) {
        slider.actionBlock = {slider, newValue in
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            slider.thumbColor = UIColor(hue: newValue / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            CATransaction.commit()
        }
        slider.thumbColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RainbowView.isHidden = false
        stackView.isHidden = true
        
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
    
    @IBAction func doneBtn(_ sender: UIButton) {
        RainbowView.isHidden = true
        stackView.isHidden = false
        activityTable.reloadData()
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
//        GoalDataManager().executeProgressUpdate(NSManagedObjectContext.MR_defaultContext(), theAct: activity, theDate: date, theStatus: status)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let theRelate = relations.allObjects[(indexPath as NSIndexPath).row] as! Activity
            let theName = theRelate.name

//            let theActivity = GoalDataManager().predicateFetchActivity(NSManagedObjectContext.MR_defaultContext(), theName: theName)
            var theActivity = Activity.mr_findFirst(with: NSPredicate(format: "name == %@", theName))
            
            if theActivity == nil {
                theActivity = Activity.mr_createEntity()
                theActivity?.name = theName
                theActivity?.status = 0
            }
            
            guard let activity = theActivity else {
                return
            }
            
            relations.remove(activity)
            
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
            
            
            if (activity.mutableSetValue(forKey: "goals").count == 0) {
                activity.mr_deleteEntity()
//                GoalBackendData().postActivityLatestData()
            }
            
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 70))
        footerView!.backgroundColor = UIColor.white
        let button = UIButton (frame: CGRect (x: tableView.frame.width/2-30, y: 5, width: 60, height: 60))
        button.setImage(UIImage (named: "addBtn"), for: UIControlState())
        button.addTarget(self, action: #selector(ViewActivitiesViewController.goNext), for: UIControlEvents.touchUpInside)
        footerView!.addSubview(button)
        
        return footerView
    }
    
    @IBAction func dailyViewTap(_ gesture: UITapGestureRecognizer?) {
        
        if(isWeeklyGraphShowing) {
            UIView.transition(from: WeeklyView, to: DailyView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            UIView.transition(from: DailyView, to: WeeklyView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        isWeeklyGraphShowing = !isWeeklyGraphShowing
    }
    
    
    func setLableText(_ name: String) {
        
        var dates: [String] = ["", "", "", "", "", "", ""]
        var theDates: [String] = ["", "", "", "", "", "", ""]
        var graphPoints = [Int]()
        
//        let theActivity = GoalDataManager().predicateFetchActivity(NSManagedObjectContext.MR_defaultContext(), theName: name)
        
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
                //print(Int(theRelate.status * 1000.0))
                
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
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goNext(){
        let storyboardIdentifier = "ChooseActivitiesTableViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! ChooseActivitiesTableViewController
//        desController.index = index
        desController.theGoal = theGoal
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
}
