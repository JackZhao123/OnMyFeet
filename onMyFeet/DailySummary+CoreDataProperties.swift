//
//  DailySummary+CoreDataProperties.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DailySummary {

    @NSManaged var dateTime: String?
    @NSManaged var steps: NSNumber?
    @NSManaged var distances: NSNumber?
    @NSManaged var sleepTime: NSNumber?
    @NSManaged var client: Person?

}
