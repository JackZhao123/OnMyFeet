//
//  File.swift
//  OnMyFeet
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import Foundation
import CoreData

@objc(Goal)
class Goal: NSManagedObject {
    
}

@objc(Activity)
class Activity: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var status: Float
}

@objc(ActivityProgress)
class ActivityProgress: NSManagedObject {
    @NSManaged var date: String
    @NSManaged var status: Float
}