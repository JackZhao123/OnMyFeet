//
//  Alarm.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-02.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import CoreData


class Alarm: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init() {
        let context = ClientDataManager.sharedInstance().managedObjectContext
        let entity = NSEntityDescription.entityForName("Alarm", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}
