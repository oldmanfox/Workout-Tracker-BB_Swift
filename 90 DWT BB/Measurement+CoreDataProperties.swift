//
//  Measurement+CoreDataProperties.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 7/5/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Measurement {

    @NSManaged var chest: String?
    @NSManaged var date: NSDate?
    @NSManaged var hips: String?
    @NSManaged var leftArm: String?
    @NSManaged var leftThigh: String?
    @NSManaged var month: String?
    @NSManaged var rightArm: String?
    @NSManaged var rightThigh: String?
    @NSManaged var session: String?
    @NSManaged var waist: String?
    @NSManaged var weight: String?

}
