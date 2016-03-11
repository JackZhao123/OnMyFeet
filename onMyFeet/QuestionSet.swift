//
//  QuestionSet.swift
//  
//
//  Created by Zhao Xiongbin on 2016-03-11.
//
//

import Foundation
import CoreData


class QuestionSet: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init() {
        let entity = NSEntityDescription.entityForName("QuestionSet", inManagedObjectContext: ClientDataManager.sharedInstance().managedObjectContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: ClientDataManager.sharedInstance().managedObjectContext)
    }
}
