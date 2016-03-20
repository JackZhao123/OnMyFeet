//
//  File.swift
//  OnMyFeet
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class GoalDataManager: NSObject, NSFetchedResultsControllerDelegate {
    var goal: Goal?
    var activity: Activity?
    var goals = [Goal]()
    var activities = [Activity]()
    var theRelate: NSMutableSet?
    var fetchResultController: NSFetchedResultsController!
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func insertGoalData(context: NSManagedObjectContext, picture: UIImage, question:String, example: String, answer: String) {
        goal = NSEntityDescription.insertNewObjectForEntityForName("Goal", inManagedObjectContext: context) as? Goal
        goal!.picture = UIImageJPEGRepresentation(picture, 1.0)!
        goal!.question = question
        goal!.example = example
        goal!.answer = answer
    }
    
    func insertActivityData (context: NSManagedObjectContext, name: String, status: Float) -> Activity {
        activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: context) as? Activity
        activity!.name = name
        activity!.status = status
        return activity!
    }
    
    func insertRelation(theGoal: Goal, theAct: Activity) {
        theRelate = theGoal.mutableSetValueForKey("activities")
        theRelate?.addObject(theAct)
    }
    
    func fetchGoals() -> [Goal]? {
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
        return goals
    }
    
    func fetchActivities() -> [Activity]? {
        let fetchRequest = NSFetchRequest (entityName: "Activity")
        let sortDescriptor = NSSortDescriptor (key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                activities = fetchResultController.fetchedObjects as! [Activity]
            }catch {
                print(error)
            }
        }
        return activities
    }
    
    func predicateFetchActivity(context: NSManagedObjectContext, theName: String) -> Activity {
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", theName)
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [Activity]
            if (result.count == 0) {
                activity = GoalDataManager().insertActivityData(context, name: theName, status: 0)
            }
            else {
                activity = result[0]
            }
        }
        catch {
            print(error)
        }
        return activity!
    }
    
    func predicateFetchGoal(theExample: String) -> Goal {
        if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDel.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Goal")
            fetchRequest.predicate = NSPredicate(format: "example == %@", theExample)
            
            do {
                let result = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Goal]
                goal = result[0]
            }
            catch {
                print(error)
            }
        }
        return goal!
    }
    
    func updateGoalAnswer(theGoal: Goal, answer: String) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            theGoal.answer = answer
            save(managedObjectContext)
        }
    }
    
    
    func updateActivityStatus(theAct: Activity, status: Float) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            theAct.status = status
            save(managedObjectContext)
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController, tableView: UITableView) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?, tableView: UITableView) {
        switch type {
            
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController, tableView: UITableView) {
        tableView.endUpdates()
    }
    
    

    func deleteAll() {
        if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDel.managedObjectContext
            let coord = appDel.persistentStoreCoordinator
            let fetchRequest = NSFetchRequest(entityName: "Goal")
            let deleteRequest = NSBatchDeleteRequest (fetchRequest: fetchRequest)
            
            do {
                try coord.executeRequest (deleteRequest, withContext: managedObjectContext)
            } catch {
                print(error)
            }
        }
    }
    
    func goalEntityIsEmpty() -> Bool {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest (entityName: "Goal")
            do{
                try managedObjectContext.executeFetchRequest(fetchRequest)
            } catch {
                print(error)
            }
            let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
            if count == 0 {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    func activityEntityIsEmpty() -> Bool {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest (entityName: "Activity")
            do{
                try managedObjectContext.executeFetchRequest(fetchRequest)
            } catch {
                print(error)
            }
            let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
            if count == 0 {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
}
