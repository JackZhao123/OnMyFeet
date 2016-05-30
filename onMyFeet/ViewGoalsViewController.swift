//
//  ViewGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ViewGoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var goalTable: UITableView!
    @IBOutlet weak var setGoalsBtn: UIButton!
    
    
    var goals = [Goal]()
    var fetchResultController: NSFetchedResultsController!
    
    
    @IBAction func setGoalsAction(sender: UIButton) {
        goNext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTable.delegate = self
        goalTable.dataSource = self
        
        let fetchRequest = NSFetchRequest (entityName: "Goal")
        let sortDescriptor = NSSortDescriptor (key: "question", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                goals = fetchResultController.fetchedObjects as! [Goal]
            }catch {
                print(error)
            }
        }
        
        
        if (goals.count == 0) {
            goalTable.hidden = true
        }
        else {
            setGoalsBtn.hidden = true
            setGoalsBtn.enabled = false
        }
        
        self.title = "My Goals"
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewGoalsViewController.goBack))
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        let nextBtn = UIBarButtonItem(title: "Add Goals", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewGoalsViewController.goNext))
        nextBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = nextBtn
        
        setGoalsBtn.layer.cornerRadius = 5.0;
        setGoalsBtn.layer.borderColor = UIColor.grayColor().CGColor
        setGoalsBtn.layer.borderWidth = 1.5
    }
    
    override func viewWillAppear(animated: Bool) {
        goalTable.setContentOffset(CGPointZero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewGoalsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ViewGoalsTableViewCell
        
        let goal = goals[indexPath.row]
        
        cell.theImage.image = UIImage (data: goal.picture)
        cell.theLabel.text = goal.answer
        cell.theLabel.delegate = self
        
        return cell
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        let point = textView.convertPoint(textView.bounds.origin, toView: self.goalTable)
//        let indexPath = self.goalTable.indexPathForRowAtPoint(point)
//        self.goalTable.scrollToRowAtIndexPath(indexPath!, atScrollPosition: .Middle, animated: true)
//        print(indexPath)
//    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let point = textView.convertPoint(textView.bounds.origin, toView: self.goalTable)
        let index = self.goalTable.indexPathForRowAtPoint(point)?.row
        let theGoal = goals[index!]
        
        GoalDataManager().updateGoalAnswer(theGoal, answer: textView.text)
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            goals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction (style: .Default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let goalToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Goal
                managedObjectContext.deleteObject(goalToDelete)
                GoalDataManager().save(managedObjectContext)
            }
            
        })
        return [deleteAction]
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        goalTable.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            
        case .Insert:
            if let _newIndexPath = newIndexPath {
                goalTable.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if let _indexPath = indexPath {
                goalTable.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
            
        case .Update:
            if let _indexPath = indexPath {
                goalTable.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            goalTable.reloadData()
        }
        goals = controller.fetchedObjects as! [Goal]
        if goals.count == 0 {
            goalTable.hidden = true
            setGoalsBtn.hidden = false
            setGoalsBtn.enabled = true
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        goalTable.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.view.frame.height > self.view.frame.width) {
            let theHeight = self.goalTable.frame.height / CGFloat(4)
            return theHeight
        }
        else {
            return 140
        }
    }
    
    func goBack(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goNext(){
        let storyboardIdentifier = "GoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewActivities" {
            if let des = segue.destinationViewController as? ViewActivitiesViewController {
                if let selectedGoalCell = sender as? ViewGoalsTableViewCell {
                    if let indexPath: NSIndexPath = self.goalTable.indexPathForCell(selectedGoalCell) {
                        des.index = indexPath.item
                    }
                }
            }
        }
    }
}
