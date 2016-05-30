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
    var progress: ActivityProgress?
    var goals = [Goal]()
    var activities = [Activity]()
    var progresses = [ActivityProgress]()
    var actGoalRelate: NSMutableSet?
    var progressActRelate: NSMutableSet?
    var fetchResultController: NSFetchedResultsController!
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func insertProgressData (context: NSManagedObjectContext, date: String, status: Float) -> ActivityProgress {
        progress = NSEntityDescription.insertNewObjectForEntityForName("ActivityProgress", inManagedObjectContext: context) as? ActivityProgress
        progress!.date = date
        progress!.status = status
        return progress!
    }
    
    func insertActGoalRelation (theGoal: Goal, theAct: Activity) {
        actGoalRelate = theGoal.mutableSetValueForKey("activities")
        actGoalRelate?.addObject(theAct)
    }
    
    func insertProgressActRelation (theAct: Activity, theProgress: ActivityProgress) {
        progressActRelate = theAct.mutableSetValueForKey("activityProgresses")
        progressActRelate?.addObject(theProgress)
    }
    
    func predicateFetchActivity(context: NSManagedObjectContext, theName: String) -> Activity {
        let predicate = NSPredicate(format: "name == %@", theName)
        var theActivity = Activity.MR_findFirstWithPredicate(predicate)
        
        if theActivity == nil {
            theActivity = Activity.MR_createEntity()
            theActivity?.name = theName
            theActivity?.status = 0
        }
        
        return theActivity!
    }
    
    func executeProgressUpdate(context: NSManagedObjectContext, theAct: Activity, theDate: String, theStatus: Float) {
        let fetchRequest = NSFetchRequest(entityName: "ActivityProgress")
        fetchRequest.predicate = NSPredicate(format: "activity.name == %@ AND date == %@", theAct.name, theDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [ActivityProgress]
            if (result.count == 0) {
                let progress = insertProgressData(context, date: theDate, status: theStatus)
                insertProgressActRelation(theAct, theProgress: progress)
                save(context)
            }
            else {
                updateProgressStatus(result[0], status: theStatus)
            }
        }
        catch {
            print(error)
        }
    }
    
    func updateProgressStatus(theProgress: ActivityProgress, status: Float) {
        theProgress.status = status
        save(NSManagedObjectContext.MR_defaultContext())
    }
    
//    func insertGoalData(context: NSManagedObjectContext, picture: UIImage, question:String, example: String, answer: String) {
//        goal = NSEntityDescription.insertNewObjectForEntityForName("Goal", inManagedObjectContext: context) as? Goal
//        goal!.picture = UIImageJPEGRepresentation(picture, 1.0)!
//        goal!.question = question
//        goal!.example = example
//        goal!.answer = answer
//    }
    
//    func insertActivityData (context: NSManagedObjectContext, name: String, status: Float) -> Activity {
//        activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: context) as? Activity
//        activity!.name = name
//        activity!.status = status
//        return activity!
//    }
    
//
//    func fetchGoals() -> [Goal]? {
//        let fetchRequest = NSFetchRequest (entityName: "Goal")
//        let sortDescriptor = NSSortDescriptor (key: "question", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        fetchResultController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.MR_defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
//        fetchResultController.delegate = self
//        do {
//            try fetchResultController.performFetch()
//            goals = fetchResultController.fetchedObjects as! [Goal]
//        }catch {
//            print(error)
//        }
//        
//        return goals
//    }
    

//    func fetchActivities() -> [Activity]? {
//        let fetchRequest = NSFetchRequest (entityName: "Activity")
//        let sortDescriptor = NSSortDescriptor (key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        fetchResultController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.MR_defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
//        fetchResultController.delegate = self
//        do {
//            try fetchResultController.performFetch()
//            activities = fetchResultController.fetchedObjects as! [Activity]
//        }catch {
//            print(error)
//        }
//        return activities
//    }
    
//    func predicateFetchGoal(theExample: String) -> Goal {
//        let fetchRequest = NSFetchRequest(entityName: "Goal")
//        fetchRequest.predicate = NSPredicate(format: "example == %@", theExample)
//        
//        do {
//            let result = try NSManagedObjectContext.MR_defaultContext().executeFetchRequest(fetchRequest) as! [Goal]
//            goal = result[0]
//        }
//        catch {
//            print(error)
//        }
//        
//        return goal!
//    }
    
//    func updateGoalAnswer(theGoal: Goal, answer: String) {
//        theGoal.answer = answer
//        save(NSManagedObjectContext.MR_defaultContext())
//    }
    
    
//    func updateActivityStatus(theAct: Activity, status: Float) {
//        theAct.status = status
//        save(NSManagedObjectContext.MR_defaultContext())
//    }

//    func deleteGoal(theGoal: Goal) {
//        
//        NSManagedObjectContext.MR_defaultContext().deleteObject(theGoal)
//        save(NSManagedObjectContext.MR_defaultContext())
//    }
    
//    func deleteActivity(theActivity: Activity) {
//        NSManagedObjectContext.MR_defaultContext().deleteObject(theActivity)
//        save(NSManagedObjectContext.MR_defaultContext())
//    }
    
//    func goalEntityIsEmpty() -> Bool {
//        let fetchRequest = NSFetchRequest (entityName: "Goal")
//        do{
//            try NSManagedObjectContext.MR_defaultContext().executeFetchRequest(fetchRequest)
//        } catch {
//            print(error)
//        }
//        let count = NSManagedObjectContext.MR_defaultContext().countForFetchRequest(fetchRequest, error: nil)
//        if count == 0 {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
//    func activityEntityIsEmpty() -> Bool {
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            let fetchRequest = NSFetchRequest (entityName: "Activity")
//            do{
//                try managedObjectContext.executeFetchRequest(fetchRequest)
//            } catch {
//                print(error)
//            }
//            let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
//            if count == 0 {
//                return true
//            }
//            else {
//                return false
//            }
//        }
//        return true
//    }
    
}
