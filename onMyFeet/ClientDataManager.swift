//
//  ClientDataManager.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "ClientsDB.sqlite"

class ClientDataManager {
    
    //Class method to a shared instance of DataManager class.
    class func sharedInstance() -> ClientDataManager {
        struct Static {
            static let instance = ClientDataManager()
        }
        
        return Static.instance
    }
    
    //MARK: Initialization
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("OnMyFeet", withExtension: "momd")!

        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        }catch{
            print(error)
            
            abort()
        }
        
        return coordinator
        
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    //MARK: DataBase Method
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchAllPersonData() -> [Person]? {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        var result: [Person]?
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [Person]
        } catch {
            print(error)
        }
        
        if let result = result {
            for p in result {
                p.summary?.count
            }
        } else {
            print("There is no data")
        }
        
        return result
    }
    
    func fetchAllSummaryData() -> [DailySummary]? {
        let fetchRequest = NSFetchRequest(entityName: "DailySummary")
        var result: [DailySummary]?
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [DailySummary]
        } catch {
            print(error)
        }
        
//        if let result = result {
//            for d in result {
//                print(d.dateTime)
//                print(d.minutesActive)
//            }
//        }
        
        return result
    }
    
    func fetchPersonWith(name:String) -> Person? {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "name = %@", argumentArray: [name])
        var result: [Person]?
        
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [Person]
        } catch {
            print(error)
        }
        
//        if let p = result?.first {
//            let summaries = p.mutableOrderedSetValueForKey("summary")
//            for s in summaries {
//                print(s)
//            }
//        }
        
        return result?.first
    }
    
    func fetchSummaryWith(dateTime:String) -> DailySummary? {
        let fetchRequest = NSFetchRequest(entityName: "DailySummary")
        fetchRequest.predicate = NSPredicate(format: "dateTime = %@", argumentArray: [dateTime])
        var result: [DailySummary]?
        
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [DailySummary]
        } catch {
            print(error)
        }
        
        return result?.first
    }
    
    func fetchIntradaySleepWith(dateTime:String, time:String) -> IntradaySleepTime? {
        let fetchRequest = NSFetchRequest(entityName: "IntradaySleepTime")
        fetchRequest.predicate = NSPredicate(format: "dateTime = %@ && time = %@", argumentArray: [dateTime,time])
        var result: [IntradaySleepTime]?
        
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [IntradaySleepTime]
        } catch {
            print(error)
        }
        
        return result?.first
    }
    
    func fetchSingleDaySleepWith(dateTime:String) -> [IntradaySleepTime]? {
        let fetchRequest = NSFetchRequest(entityName: "IntradaySleepTime")
        fetchRequest.predicate = NSPredicate(format: "dateTime = %@", argumentArray: [dateTime])
        var result: [IntradaySleepTime]?
        
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest) as? [IntradaySleepTime]
        } catch {
            print(error)
        }
        
        return result
    }
    
    func fetchDataOf(entity:String, parameter:[String], argument:[String]) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest(entityName: entity)
        var formatString = "\(parameter.first!) = %@"
        if parameter.count > 1 {
            for index in 1...parameter.count - 1 {
                formatString = NSString(string: formatString).stringByAppendingString("&& \(parameter[index]) = %@")
            }
        }
        
        fetchRequest.predicate = NSPredicate(format: formatString, argumentArray: argument)
        var result: [AnyObject]?
        
        do {
            try result = self.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            print(error)
        }
        
        return result
    }
    
    func deleteAllPersonData() {
        if let result = self.fetchAllPersonData() {
            for p in result {
                self.managedObjectContext.deleteObject(p)
                saveContext()
            }
        }
    }
    
    func createPersonData(name: String) {
        let person = Person()
        person.setValue(name, forKey: "name")
        person.setValue(NSOrderedSet(), forKey: "summary")
        saveContext()
    }
    
    //MARK: Testing Method
    func populatePersonData() {
        let person = Person()
        person.setValue("Xiongbin Zhao", forKey: "name")
        
        saveContext()
    }
    
    func populateSummaryData() {
        let summary = DailySummary()
        summary.setValue("2016-02-12", forKey: "dateTime")
        saveContext()
    }
    
    func add(summary:DailySummary, toPersonWithName name:String){
        if let person = fetchPersonWith(name){
            let summaries = person.mutableOrderedSetValueForKey("summary")
            summaries.addObject(summary)
            saveContext()
        }
    }
    
    //MARK: QuestionSet
    func initQuestionSetData() {
        let questionnaireSample = QuestionnaireSample()
        
        let questionnaire1 = QuestionSet()
        questionnaire1.title = "Rehab self-efficacy scale"
        questionnaire1.symptom = "For everyone-1st check-in"
//        var qSet1 = Questionnaire()
//        qSet1.testEntry = "During my rehabilitation,\nI believe I can do..."
//        qSet1.numberOfValue = 11
//        qSet1.labelDic = [0:"I cannot do it", 10:"I can do it"]
//        qSet1.questionSet = ["Therapy that requires me to stretch my leg", "Therapy that requires me to lift my leg ", "Therapy that requires me to bend my leg", "Therapy that requires me to stand", "Therapy that requires me to walk", "All of my therapy exercises during my rehabilitation","My therapy every day that it is scheduled", "The exercises my therapists say I should do, even if I don’t understand how it helps me","My therapy no matter how I feel emotionally","My therapy no matter how tired I may feel", "My therapy even though I may already have other complicating illnesses", "My therapy regardless of the amount of pain I am feeling"]
        
        questionnaire1.questionnaire = NSKeyedArchiver.archivedDataWithRootObject(questionnaireSample.ser)
        
        let questionnaire2 = QuestionSet()
        questionnaire2.title = "ABC"
        questionnaire2.symptom = "Fear of losing balance or falling"
        questionnaire2.questionnaire = NSKeyedArchiver.archivedDataWithRootObject(questionnaireSample.abc)
        
        let questionnaire3 = QuestionSet()
        questionnaire3.title = "S-STAI-10"
        questionnaire3.symptom = "Feeling anxious or tense"
        questionnaire3.questionnaire = NSKeyedArchiver.archivedDataWithRootObject(questionnaireSample.stai)
        
        let questionnaire4 = QuestionSet()
        questionnaire4.title = "CES-D"
        questionnaire4.symptom = "Feeling low or hopeless"
        questionnaire4.questionnaire = NSKeyedArchiver.archivedDataWithRootObject(questionnaireSample.cesd)
    
        
        saveContext()
    }
    
    func fetchQuestionSet() -> [QuestionSet]?{
        let fetchRequest = NSFetchRequest(entityName: "QuestionSet")
        var result:[QuestionSet]?
        
        do {
            try result = managedObjectContext.executeFetchRequest(fetchRequest) as? [QuestionSet]
        } catch {
            print(error)
        }
        if let result = result {
            for s in result {
                print(s.title)
            }
        }
        
        return result
    }
    
}