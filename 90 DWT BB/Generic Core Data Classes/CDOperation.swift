//
//  CDOperation.swift
//
//  Created by Tim Roadley on 1/10/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData

class CDOperation {
 
    class func objectCountForEntity (entityName:String, context:NSManagedObjectContext) -> Int {
        
        let request = NSFetchRequest(entityName: entityName)
        var error:NSError?
        let count = context.countForFetchRequest(request, error: &error)
        
        if let _error = error {
            print("\(#function) Error: \(_error.localizedDescription)")
        } else {
            print("There are \(count) \(entityName) object(s) in \(context)")
        }
        return count
    }
    class func objectsForEntity(entityName:String, context:NSManagedObjectContext, filter:NSPredicate?, sort:[NSSortDescriptor]?) -> [AnyObject]? {

        let request = NSFetchRequest(entityName:entityName)
        request.predicate = filter
        request.sortDescriptors = sort

        do {
            return try context.executeFetchRequest(request)
        } catch {
            print("\(#function) FAILED to fetch objects for \(entityName) entity")
            return nil
        }
    }
    class func objectName(object:NSManagedObject) -> String {
        
        if let name = object.valueForKey("name") as? String {
            return name
        }
        return object.description
    }
    class func objectDeletionIsValid(object:NSManagedObject) -> Bool {
        
        do {
            try object.validateForDelete()
            return true // object can be deleted
        } catch let error as NSError {
            print("'\(objectName(object))' can't be deleted. \(error.localizedDescription)")
            return false // object can't be deleted
        }
    }
    class func objectWithAttributeValueForEntity(entityName:String, context:NSManagedObjectContext, attribute:String, value:String) -> NSManagedObject? {
        
        let predicate = NSPredicate(format: "%K == %@", attribute, value)
        let objects = CDOperation.objectsForEntity(entityName, context: context, filter: predicate, sort: nil)
        if let object = objects?.first as? NSManagedObject {
            return object
        }
        return nil
    }
    class func predicateForAttributes (attributes:[NSObject:AnyObject], type:NSCompoundPredicateType ) -> NSPredicate? {
            
        // Create an array of predicates, which will be later combined into a compound predicate.
        var predicates:[NSPredicate]?
            
        // Iterate unique attributes in order to create a predicate for each
        for (attribute, value) in attributes {
                
            var predicate:NSPredicate?
                
            // If the value is a string, create the predicate based on a string value
            if let stringValue = value as? String {
                predicate = NSPredicate(format: "%K == %@", attribute, stringValue)
            }
                
            // If the value is a number, create the predicate based on a numerical value
            if let numericalValue = value as? NSNumber {
                predicate = NSPredicate(format: "%K == %@", attribute, numericalValue)
            }
                
            // Append new predicate to predicate array, or create it if it doesn't exist yet
            if let newPredicate = predicate {
                if var _predicates = predicates {
                    _predicates.append(newPredicate)
                } else {predicates = [newPredicate]}
            }
        }
            
        // Combine all predicates into a compound predicate
        if let _predicates = predicates {
            return NSCompoundPredicate(type: type, subpredicates: _predicates)
        }
        return nil
    } 
    class func uniqueObjectWithAttributeValuesForEntity(entityName:String, context:NSManagedObjectContext, uniqueAttributes:[NSObject:AnyObject]) -> NSManagedObject? {
            
        let predicate = CDOperation.predicateForAttributes(uniqueAttributes, type: .AndPredicateType)
        let objects = CDOperation.objectsForEntity(entityName, context: context, filter: predicate, sort: nil)
            
        if objects?.count > 0 {
            if let object = objects?[0] as? NSManagedObject {
                return object
            }
        }
        return nil
    }
    class func insertUniqueObject(entityName:String, context:NSManagedObjectContext, uniqueAttributes:[String:AnyObject], additionalAttributes:[String:AnyObject]?) -> NSManagedObject {
            
        // Return existing object after adding the additional attributes.
        if let existingObject = CDOperation.uniqueObjectWithAttributeValuesForEntity(entityName, context: context, uniqueAttributes: uniqueAttributes) {            
            if let _additionalAttributes = additionalAttributes {
                 existingObject.setValuesForKeysWithDictionary(_additionalAttributes)
            }
            return existingObject
        }
            
        // Create object with given attribute value
        let newObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)
        newObject.setValuesForKeysWithDictionary(uniqueAttributes)
        if let _additionalAttributes = additionalAttributes {
            newObject.setValuesForKeysWithDictionary(_additionalAttributes)
        }
        return newObject 
    }
    
    class func saveWithPredicate(session: String, routine: String, workout: String, exercise: String, round: String, index: String, weight: String) {
        
        let request = NSFetchRequest( entityName: "Workout")
        //let sort = NSSortDescriptor( key: "name", ascending: true)
        //request.sortDescriptors = [sort]
        let filter = NSPredicate( format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND round == %@ AND index == %@",
                                  session,
                                  routine,
                                  workout,
                                  exercise,
                                  round,
                                  index)
        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest( request) as? [Workout] {
                
                print("workoutObjects.count = \(workoutObjects.count)")
                
                if workoutObjects.count == 0 {
                    
                    // No matches for this object.  Insert a new record
                    
                    let insertWorkoutInfo = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: CDHelper.shared.context) as! Workout
                    
                    let todaysDate = NSDate()
                    
                    insertWorkoutInfo.session = session
                    insertWorkoutInfo.routine = routine
                    insertWorkoutInfo.workout = workout
                    insertWorkoutInfo.exercise = workout
                    insertWorkoutInfo.round = Int(round)
                    insertWorkoutInfo.index = Int(index)
                    insertWorkoutInfo.weight = weight
                    insertWorkoutInfo.date = todaysDate
                        
                        
                    CDHelper.saveSharedContext()
                    
                }
                else {
                    
                
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        print("workoutObject = nil")
        
    }
}
