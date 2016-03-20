//
//  File.swift
//  OnMyFeet
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import Foundation
import CoreData

class Goal: NSManagedObject {
    @NSManaged var picture: NSData
    @NSManaged var question: String
    @NSManaged var example: String
    @NSManaged var answer: String
}

class Activity: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var status: Float
}
