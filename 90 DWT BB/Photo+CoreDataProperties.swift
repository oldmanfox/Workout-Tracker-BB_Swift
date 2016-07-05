//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var angle: String?
    @NSManaged var date: NSDate?
    @NSManaged var image: NSData?
    @NSManaged var month: String?
    @NSManaged var session: String?

}
