//
//  Alarm+CoreDataProperties.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-02.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Alarm {

    @NSManaged var time: String?
    @NSManaged var label: String?
    @NSManaged var id: String?
    @NSManaged var period: NSData?
    @NSManaged var on: NSNumber?

}
