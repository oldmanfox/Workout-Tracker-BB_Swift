//
//  Workout+CoreDataProperties.swift
//  90 DWT BB
//
//  Created by Jared Grant on 7/10/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Workout {

    @NSManaged var date: NSDate?
    @NSManaged var exercise: String?
    @NSManaged var index: NSNumber?
    @NSManaged var month: String?
    @NSManaged var notes: String?
    @NSManaged var photo: String?
    @NSManaged var reps: String?
    @NSManaged var round: NSNumber?
    @NSManaged var routine: String?
    @NSManaged var session: String?
    @NSManaged var week: String?
    @NSManaged var weight: String?
    @NSManaged var workout: String?
    @NSManaged var weight1: String?
    @NSManaged var weight2: String?
    @NSManaged var weight3: String?
    @NSManaged var weight4: String?
    @NSManaged var weight5: String?
    @NSManaged var weight6: String?
    @NSManaged var repsNumber1: String?
    @NSManaged var repsNumber2: String?
    @NSManaged var repsNumber3: String?
    @NSManaged var repsNumber4: String?
    @NSManaged var repsNumber5: String?
    @NSManaged var repsNumber6: String?
    @NSManaged var tableViewSection: NSNumber?
    @NSManaged var tableViewRow: NSNumber?
    @NSManaged var repsTitle1: String?
    @NSManaged var repsTitle2: String?
    @NSManaged var repsTitle3: String?
    @NSManaged var repsTitle4: String?
    @NSManaged var repsTitle5: String?
    @NSManaged var repsTitle6: String?
    @NSManaged var cellType: String?

}
