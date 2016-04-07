//
//  Person.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import CoreData


class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(){
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: ClientDataManager.sharedInstance().managedObjectContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: ClientDataManager.sharedInstance().managedObjectContext)
    }

}
