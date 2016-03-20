//
//  ViewActivitiesViewController.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

class ViewActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var RainbowBar: UIView!
    @IBOutlet weak var theSlider: GradientSlider!
    @IBOutlet weak var actLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var index: Int = 0
    var goals = [Goal]()
    var theGoal: Goal?
    var theActivity: Activity?
    var relations: NSMutableSet = []
    var flag = false
    var theStatus: Float = 0.0
    var theName: String = ""
    var footerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.delegate = self
        activityTable.dataSource = self
        
        goals = GoalDataManager().fetchGoals()!
        
        theGoal = goals[index]
        relations = (theGoal?.mutableSetValueForKey("activities"))!
        
        self.title = "My Activities"
    
        show()
        RainbowBar.hidden = true
        stackView.hidden = false
        textView.hidden = false
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        let nextBtn = UIBarButtonItem(title: "Delete All", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteAll")
        nextBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = nextBtn
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        doneBtn.layer.cornerRadius = 5.0;
        doneBtn.layer.borderColor = UIColor.grayColor().CGColor
        doneBtn.layer.borderWidth = 1.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show() {
        imageView.image = UIImage (data: goals[index].picture)
        textView.text = goals[index].answer
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
        RainbowBar.hidden = false
        stackView.hidden = true
        
        let theRelate = relations.allObjects[indexPath.row]
        theName = String(theRelate.valueForKey("name")!)
        theStatus = Float(String(theRelate.valueForKey("status")!))!
        
        actLabel.text = theName
        theSlider.value = CGFloat(theStatus)
        theSlider.thumbColor = UIColor(hue: CGFloat(theStatus) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        chooseSlider(theSlider, status: CGFloat(theStatus))
        saveStatus(theSlider, indexPath: indexPath)
        
    }
    
    @IBAction func doneBtn(sender: UIButton) {
        RainbowBar.hidden = true
        stackView.hidden = false
        activityTable.reloadData()
    }
    
    func changeStatus(name: String, status: Float) {
        if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDel.managedObjectContext
            let theActivity = GoalDataManager().predicateFetchActivity(managedObjectContext, theName: name)
            GoalDataManager().updateActivityStatus(theActivity, status: status)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
                let managedObjectContext = appDel.managedObjectContext
                let theName = String(relations.allObjects[indexPath.row].valueForKey("name")!)
                let theActivity = GoalDataManager().predicateFetchActivity(managedObjectContext, theName: theName)
                relations.removeObject(theActivity)
                GoalDataManager().save(managedObjectContext)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade )
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            }
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
        button.addTarget(self, action: "goNext", forControlEvents: UIControlEvents.TouchUpInside)
        footerView!.addSubview(button)
        
        return footerView
    }
    
    func deleteAll() {
        let theGoal = goals[index]
        theGoal.setValue(nil, forKey: "activities")
        if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDel.managedObjectContext
            GoalDataManager().save(managedObjectContext)
        }
        relations = []
        activityTable.reloadData()
    }
    
    func goBack(){
        let storyboardIdentifier = "ViewGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! ViewGoalsViewController
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    func goNext(){
        let storyboardIdentifier = "ChooseActivitiesTableViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! ChooseActivitiesTableViewController
        desController.index = index
        self.navigationController!.pushViewController(desController, animated: true)
    }

}
