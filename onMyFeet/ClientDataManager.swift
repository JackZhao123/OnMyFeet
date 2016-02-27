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
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
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
                print(p.name!)
            }
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
        
        return result?.first
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
    
}