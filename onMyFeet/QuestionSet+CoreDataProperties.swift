//
//  QuestionSet+CoreDataProperties.swift
//  
//
//  Created by Zhao Xiongbin on 2016-03-11.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QuestionSet {

    @NSManaged var title: String?
    @NSManaged var symptom: String?
    @NSManaged var questionnaire: Data?

}
