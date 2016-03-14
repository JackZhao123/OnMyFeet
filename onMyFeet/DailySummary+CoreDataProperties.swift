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
    @NSManaged var distance: NSNumber?
    @NSManaged var minutesAsleep: NSNumber?
    @NSManaged var minutesActive: NSNumber?
//    @NSManaged var minutesFairlyActive: NSNumber?
    @NSManaged var minutesLightlyActive: NSNumber?
    @NSManaged var minutesSedentary: NSNumber?
//    @NSManaged var minutesVeryActive: NSNumber?

    @NSManaged var client: Person?
    @NSManaged var intradaySedentary: NSOrderedSet?

}
