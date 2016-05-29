//
//  ViewActivitiesViewController.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ViewActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
        
        relations = (theGoal!.mutableSetValueForKey("activities"))
        
        self.title = "My Activities"
    
        show()
        
        RainbowView.hidden = true
        stackView.hidden = false
        textView.hidden = false
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewActivitiesViewController.goHome))
        homeBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = homeBtn
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        doneBtn.layer.cornerRadius = 5.0;
        doneBtn.layer.borderColor = UIColor.grayColor().CGColor
        doneBtn.layer.borderWidth = 1.5
        DailyView.layer.cornerRadius = 10.0
        greenView.layer.cornerRadius = 10.0
        redView.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(animated: Bool) {
        relations = (theGoal!.mutableSetValueForKey("activities"))
        activityTable.reloadData()
    }
    
    func show() {
        imageView.image = UIImage(data: theGoal!.picture!)
        textView.text = theGoal!.answer
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewActivitiesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ViewActivitiesTableViewCell
        
        let theRelate = relations.allObjects[indexPath.row]
        let name = String(theRelate.valueForKey("name")!)
        let status = CGFloat(Float(String(theRelate.valueForKey("status")!))!)

        cell.label.text = name
        
        cell.theSlider.thumbColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        cell.theSlider.value = status
        
        chooseSlider(cell.theSlider, status: status)
        getStatus(cell.theSlider)
        
        return cell
    }
    
    
    func getStatus(slider: GradientSlider) {
        var status: Float = 0.0
        var name: String = ""
        slider.endBlock = {slider, newValue, newLocation in
            let point = newLocation
            let pointInCell = slider.convertPoint(point, toView: self.activityTable)
            let index = self.activityTable.indexPathForRowAtPoint(pointInCell)!.row
            
            status = Float(newValue)
            name = String(self.relations.allObjects[index].valueForKey("name")!)

            self.changeStatus(name, status: status)
        }
    }
    
    func saveStatus(slider: GradientSlider, indexPath: NSIndexPath) {
        var status: Float = 0.0
        var name: String = ""
        slider.endBlock = {slider, newValue, newLocation in
            let theRelate = self.relations.allObjects[indexPath.row]
            name = String(theRelate.valueForKey("name")!)
            status = Float(newValue)
            self.changeStatus(name, status: status)
        }
    }
    
    
    func chooseSlider(slider: GradientSlider, status: CGFloat) {
        slider.actionBlock = {slider, newValue in
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            slider.thumbColor = UIColor(hue: newValue / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            CATransaction.commit()
        }
        slider.thumbColor = UIColor(hue: status / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        RainbowView.hidden = false
        stackView.hidden = true
        
        let theRelate = relations.allObjects[indexPath.row]
        theName = String(theRelate.valueForKey("name")!)
        theStatus = Float(String(theRelate.valueForKey("status")!))!
        
        actLabel.text = theName
        theSlider.value = CGFloat(theStatus)
        theSlider.thumbColor = UIColor(hue: CGFloat(theStatus) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        chooseSlider(theSlider, status: CGFloat(theStatus))
        saveStatus(theSlider, indexPath: indexPath)
        setLableText(theName)
    }
    
    @IBAction func doneBtn(sender: UIButton) {
        RainbowView.hidden = true
        stackView.hidden = false
        activityTable.reloadData()
    }
    
    func changeStatus(name: String, status: Float) {
        let predicate = NSPredicate(format: "name == %@", name)
        var theActivity = Activity.MR_findFirstWithPredicate(predicate)
        if theActivity == nil {
            theActivity = Activity.MR_createEntity()
        }
        
        theActivity!.name = name
        theActivity!.status = status
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        let date = getDate()
        GoalDataManager().executeProgressUpdate(NSManagedObjectContext.MR_defaultContext(), theAct: theActivity!, theDate: date, theStatus: status)
        setLableText(name)
    }
    
    func getDate() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components ([.Day, .Month, .Year], fromDate: date)
        
        let year = String(components.year)
        let month = String(format: "%02d", components.month)
        let day = String(format: "%02d", components.day)
        
        let theDate = year + month + day
        return theDate
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let theName = String(relations.allObjects[indexPath.row].valueForKey("name")!)
            let theActivity = GoalDataManager().predicateFetchActivity(NSManagedObjectContext.MR_defaultContext(), theName: theName)
            relations.removeObject(theActivity)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade )
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            
            
            if (theActivity.mutableSetValueForKey("goals").count == 0) {
                theActivity.MR_deleteEntity()
//                GoalBackendData().postActivityLatestData()
            }
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView (frame: CGRectMake (0, 0, tableView.frame.width, 70))
        footerView!.backgroundColor = UIColor.whiteColor()
        let button = UIButton (frame: CGRectMake (tableView.frame.width/2-30, 5, 60, 60))
        button.setImage(UIImage (named: "addBtn"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ViewActivitiesViewController.goNext), forControlEvents: UIControlEvents.TouchUpInside)
        footerView!.addSubview(button)
        
        return footerView
    }
    
    @IBAction func dailyViewTap(gesture: UITapGestureRecognizer?) {
        
        if(isWeeklyGraphShowing) {
        UIView.transitionFromView(WeeklyView, toView: DailyView, duration: 1.0, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], completion: nil)
        }
        else {
            UIView.transitionFromView(DailyView, toView: WeeklyView, duration: 1.0, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: nil)
        }
        isWeeklyGraphShowing = !isWeeklyGraphShowing    
    }
    
    
    func setLableText(name: String) {
        
        var dates: [String] = ["", "", "", "", "", "", ""]
        var theDates: [String] = ["", "", "", "", "", "", ""]
        var graphPoints = [Int]()
        
        let theActivity = GoalDataManager().predicateFetchActivity(NSManagedObjectContext.MR_defaultContext(), theName: name)
        progressRelations = theActivity.mutableSetValueForKey("activityProgresses")
        let theArray: NSArray = progressRelations.sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: true)])
        
        if progressRelations.count > 7 {
            for index in 0..<7 {
                let theRelate = theArray.objectAtIndex(progressRelations.count-(7-index))
                
                dates[index] = String(theRelate.valueForKey("date")!)
                theDates[index] = dates[index].substringWithRange(Range<String.Index> (dates[index].startIndex.advancedBy(4)..<dates[index].endIndex.advancedBy(-2))) + "/" + dates[index].substringWithRange(Range<String.Index> (dates[index].endIndex.advancedBy(-2)..<dates[index].endIndex))
                
                graphPoints.append(Int(Float(String(theRelate.valueForKey("status")!))! * 1000))
            }
            print(graphPoints)
            print(dates)
        }

        else {
            for index in 0..<progressRelations.count {
                let theRelate = theArray.objectAtIndex(index)
                dates[index] = String(theRelate.valueForKey("date")!)
                
                if (dates[index].characters.count != 0) {
                    theDates[index] = dates[index].substringWithRange(Range<String.Index> (dates[index].startIndex.advancedBy(4)..<dates[index].endIndex.advancedBy(-2))) + "/" + dates[index].substringWithRange(Range<String.Index> (dates[index].endIndex.advancedBy(-2)..<dates[index].endIndex))
                }
                else {
                    theDates[index] = dates[index]
                }
                graphPoints.append(Int(Float(String(theRelate.valueForKey("status")!))! * 1000))
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goHome(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goNext(){
        let storyboardIdentifier = "ChooseActivitiesTableViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! ChooseActivitiesTableViewController
//        desController.index = index
        desController.theGoal = theGoal
        self.navigationController!.pushViewController(desController, animated: true)
    }

}
