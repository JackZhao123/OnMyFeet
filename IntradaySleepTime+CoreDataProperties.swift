//
//  IntradaySleepTime+CoreDataProperties.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-27.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension IntradaySleepTime {

    @NSManaged var time: String?
    @NSManaged var value: NSNumber?
    @NSManaged var day: DailySummary?

}
