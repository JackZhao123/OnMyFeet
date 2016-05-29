//
//  Goal+CoreDataProperties.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-05-29.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Goal {

    @NSManaged var answer: String?
    @NSManaged var example: String?
    @NSManaged var picture: NSData?
    @NSManaged var question: String?
    @NSManaged var activities: NSSet?

}
