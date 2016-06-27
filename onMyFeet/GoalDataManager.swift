//
//  File.swift
//  OnMyFeet
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

//import UIKit
//import CoreData
//
//class GoalDataManager: NSObject, NSFetchedResultsControllerDelegate {
//    var goal: Goal?
//    var activity: Activity?
//    var progress: ActivityProgress?
//    var goals = [Goal]()
//    var activities = [Activity]()
//    var progresses = [ActivityProgress]()
//    var actGoalRelate: NSMutableSet?
//    var progressActRelate: NSMutableSet?
//    var fetchResultController: NSFetchedResultsController!
//    
//    func executeProgressUpdate(context: NSManagedObjectContext, theAct: Activity, theDate: String, theStatus: Float) {
//        
//        let results = ActivityProgress.MR_findAllSortedBy("date", ascending: true, withPredicate: NSPredicate(format: "activity.name == %@ AND date == %@", theAct.name, theDate), inContext: NSManagedObjectContext.MR_defaultContext())
//        
//        
//        guard let allProgress = results as? [ActivityProgress] else {
//            return
//        }
//        
//        if (allProgress.count == 0) {
//            let progress = ActivityProgress.MR_createEntity()
//            
//            guard let newProgress = progress else {
//                return
//            }
//            
//            newProgress.date = theDate
//            newProgress.status = theStatus
//            
//            progressActRelate = theAct.mutableSetValueForKey("activityProgresses")
//            progressActRelate?.addObject(newProgress)
//            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
//        }
//        else {
//            allProgress[0].status = theStatus
//            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
//        }
//    }
    
//    func save(context: NSManagedObjectContext) {
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//    }

//    func insertProgressData (context: NSManagedObjectContext, date: String, status: Float) -> ActivityProgress {
//        progress = NSEntityDescription.insertNewObjectForEntityForName("ActivityProgress", inManagedObjectContext: context) as? ActivityProgress
//        progress!.date = date
//        progress!.status = status
//        return progress!
//    }
//
//    func insertActGoalRelation (theGoal: Goal, theAct: Activity) {
//        actGoalRelate = theGoal.mutableSetValueForKey("activities")
//        actGoalRelate?.addObject(theAct)
//    }

//    func predicateFetchActivity(context: NSManagedObjectContext, theName: String) -> Activity {
//        let predicate = NSPredicate(format: "name == %@", theName)
//        var theActivity = Activity.MR_findFirstWithPredicate(predicate)
//
//        if theActivity == nil {
//            theActivity = Activity.MR_createEntity()
//            theActivity?.name = theName
//            theActivity?.status = 0
//        }
//        
//        return theActivity!
//    }
    
//    func updateProgressStatus(theProgress: ActivityProgress, status: Float) {
//        theProgress.status = status
//        save(NSManagedObjectContext.MR_defaultContext())
//    }
    
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
    
//}
