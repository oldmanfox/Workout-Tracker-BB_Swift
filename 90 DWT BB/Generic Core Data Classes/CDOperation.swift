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
            
            // If the value is a date, create the predicate based on a date value
            if let dateValue = value as? NSDate {
                predicate = NSPredicate(format: "%K == %@", attribute, dateValue)
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
    
    class func saveWeightWithPredicate(session: String, routine: String, workout: String, exercise: String, index: NSNumber, weight: String, round: NSNumber) {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortRound = NSSortDescriptor( key: "round", ascending: true)
        let sortExercise = NSSortDescriptor(key: "exercise", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortWorkout = NSSortDescriptor(key: "workout", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortWorkout, sortExercise, sortRound]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index = %@ AND round == %@",
                                 session,
                                 routine,
                                 workout,
                                 exercise,
                                 index,
                                 round)

        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                print("workoutObjects.count = \(workoutObjects.count)")
                
                switch workoutObjects.count {
                case 0:
                    // No matches for this object.
                    // Insert a new record
                    print("No Matches")
                    let insertWorkoutInfo = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: CDHelper.shared.context) as! Workout
                    
                    insertWorkoutInfo.session = session
                    insertWorkoutInfo.routine = routine
                    insertWorkoutInfo.workout = workout
                    insertWorkoutInfo.exercise = exercise
                    insertWorkoutInfo.round = round
                    insertWorkoutInfo.index = index
                    insertWorkoutInfo.weight = weight
                    insertWorkoutInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                case 1:
                    // Update existing record
                    
                    let updateWorkoutInfo = workoutObjects[0]
                    
                    updateWorkoutInfo.weight = weight
                    updateWorkoutInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                default:
                    // More than one match
                    // Sort by most recent date and delete all but the newest
                    print("More than one match for object")
                    for index in 0..<workoutObjects.count {
                        
                        if (index == workoutObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            let updateWorkoutInfo = workoutObjects[index]
                            
                            updateWorkoutInfo.weight = weight
                            updateWorkoutInfo.date = NSDate()
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(workoutObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    class func saveNoteWithPredicate(session: String, routine: String, workout: String, exercise: String, index: NSNumber, note: String, round: NSNumber) {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortRound = NSSortDescriptor( key: "round", ascending: true)
        let sortExercise = NSSortDescriptor(key: "exercise", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortWorkout = NSSortDescriptor(key: "workout", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortWorkout, sortExercise, sortRound]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index = %@ AND round == %@",
                                 session,
                                 routine,
                                 workout,
                                 exercise,
                                 index,
                                 round)
        
        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                print("workoutObjects.count = \(workoutObjects.count)")
                
                switch workoutObjects.count {
                case 0:
                    // No matches for this object.
                    // Insert a new record
                    print("No Matches")
                    let insertWorkoutInfo = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: CDHelper.shared.context) as! Workout
                    
                    insertWorkoutInfo.session = session
                    insertWorkoutInfo.routine = routine
                    insertWorkoutInfo.workout = workout
                    insertWorkoutInfo.exercise = exercise
                    insertWorkoutInfo.round = round
                    insertWorkoutInfo.index = index
                    insertWorkoutInfo.notes = note
                    insertWorkoutInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                case 1:
                    // Update existing record
                    
                    let updateWorkoutInfo = workoutObjects[0]
                    
                    updateWorkoutInfo.notes = note
                    updateWorkoutInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                default:
                    // More than one match
                    // Sort by most recent date and delete all but the newest
                    print("More than one match for object")
                    for index in 0..<workoutObjects.count {
                        
                        if (index == workoutObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            let updateWorkoutInfo = workoutObjects[index]
                            
                            updateWorkoutInfo.notes = note
                            updateWorkoutInfo.date = NSDate()
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(workoutObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    class func getWeightTextForExercise(session: String, routine: String, workout: String, exercise: String, index: NSNumber) -> [NSManagedObject] {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortRound = NSSortDescriptor( key: "round", ascending: true)
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortRound, sortDate]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index = %@",
                                 session,
                                 routine,
                                 workout,
                                 exercise,
                                 index)
        
        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                var workoutArray = [NSManagedObject]()
                
                for outerIndex in 0...5 {
                    
                    var objectsAtIndexArray = [NSManagedObject]()
                    
                    for object in workoutObjects {
                        
                        if object.round == outerIndex {
                            objectsAtIndexArray.append(object)
                        }
                    }
                    
                    if objectsAtIndexArray.count != 0 {
                        
                        workoutArray.append(objectsAtIndexArray.last!)
                    }
                    
                }
                
                return workoutArray
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return []
    }
    
    class func getWeightTextForExerciseRound(session: String, routine: String, workout: String, exercise: String, round: NSNumber, index: NSNumber) -> String? {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index = %@ AND round = %@",
                                 session,
                                 routine,
                                 workout,
                                 exercise,
                                 index,
                                 round)
        
        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                switch workoutObjects.count {
                case 0:
                    // No matches for this object.
                    
                    return "0.0"
                    
                case 1:
                    let matchedWorkoutInfo = workoutObjects[0]
                    
                    return matchedWorkoutInfo.weight
                    
                default:
                    // More than one match
                    // Sort by most recent date and pick the newest
                    print("More than one match for object")
                    let matchedWorkoutInfo = workoutObjects.last
                    
                    return matchedWorkoutInfo!.weight
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return "0.0"
    }
    
    class func getCurrentRoutine() -> String {
        
        let request = NSFetchRequest( entityName: "Routine")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let routineObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Routine] {
                
                print("routineObjects.count = \(routineObjects.count)")
                
                switch routineObjects.count {
                case 0:
                    // No matches for this object.
                    // Create a new record with the default routine - Bulk
                    let insertRoutineInfo = NSEntityDescription.insertNewObjectForEntityForName("Routine", inManagedObjectContext: CDHelper.shared.context) as! Routine
                    
                    insertRoutineInfo.defaultRoutine = "Bulk"
                    insertRoutineInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                    // Return the default routine.
                    // Will be Bulk until the user changes it in settings tab.
                    return "Bulk"
                    
                case 1:
                    // Found an existing record
                    let matchedRoutineInfo = routineObjects[0]
                    
                    return matchedRoutineInfo.defaultRoutine!
                    
                default:
                    // More than one match
                    // Sort by most recent date and pick the newest
                    print("More than one match for object")
                    var routineString = ""
                    for index in 0..<routineObjects.count {
                        
                        if (index == routineObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            
                            let matchedRoutineInfo = routineObjects[index]
                            routineString = matchedRoutineInfo.defaultRoutine!
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(routineObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                    return routineString
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }

        return "Bulk"
    }
    
    class func getCurrentSession() -> String {
        
        let request = NSFetchRequest( entityName: "Session")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let sessionObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Session] {
                
                print("sessionObjects.count = \(sessionObjects.count)")
                
                switch sessionObjects.count {
                case 0:
                    // No matches for this object.
                    // Create a new record with the default session - 1
                    let insertSessionInfo = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: CDHelper.shared.context) as! Session
                    
                    insertSessionInfo.currentSession = "1"
                    insertSessionInfo.date = NSDate()
                    
                    CDHelper.saveSharedContext()
                    
                    // Return the default routine.
                    // Will be 1 until the user changes it in settings tab.
                    return "1"
                    
                case 1:
                    // Found an existing record
                    let matchedSessionInfo = sessionObjects[0]
                    
                    return matchedSessionInfo.currentSession!
                    
                default:
                    // More than one match
                    // Sort by most recent date and pick the newest
                    print("More than one match for object")
                    var sessionString = ""
                    for index in 0..<sessionObjects.count {
                        
                        if (index == sessionObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            
                            let matchedSessionInfo = sessionObjects[index]
                            sessionString = matchedSessionInfo.currentSession!
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(sessionObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                    return sessionString
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return "1"
    }
    
    class func saveWorkoutCompleteDate(session: NSString, routine: NSString, workout: NSString, index: NSNumber, useDate: NSDate) {
        
        let request = NSFetchRequest( entityName: "WorkoutCompleteDate")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@",
                                 session,
                                 routine,
                                 workout,
                                 index)
        
        request.predicate = filter

        do {
            if let workoutCompleteDateObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [WorkoutCompleteDate] {
                
                print("workoutCompleteDateObjects.count = \(workoutCompleteDateObjects.count)")
                
                switch workoutCompleteDateObjects.count {
                case 0:
                    // No matches for this object.
                    // Insert a new record
                    print("No Matches")
                    let insertWorkoutInfo = NSEntityDescription.insertNewObjectForEntityForName("WorkoutCompleteDate", inManagedObjectContext: CDHelper.shared.context) as! WorkoutCompleteDate
                    
                    insertWorkoutInfo.session = session as String
                    insertWorkoutInfo.routine = routine as String
                    insertWorkoutInfo.workout = workout as String
                    insertWorkoutInfo.index = index
                    insertWorkoutInfo.workoutCompleted = true
                    insertWorkoutInfo.date = useDate
                    
                    CDHelper.saveSharedContext()
                    
                case 1:
                    // Update existing record
                    
                    let updateWorkoutInfo = workoutCompleteDateObjects[0]
                    
                    updateWorkoutInfo.workoutCompleted = true
                    updateWorkoutInfo.date = useDate
                    
                    CDHelper.saveSharedContext()
                    
                default:
                    // More than one match
                    // Sort by most recent date and delete all but the newest
                    print("More than one match for object")
                    for index in 0..<workoutCompleteDateObjects.count {
                        
                        if (index == workoutCompleteDateObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            let updateWorkoutInfo = workoutCompleteDateObjects[index]
                            
                            updateWorkoutInfo.workoutCompleted = true
                            updateWorkoutInfo.date = useDate
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(workoutCompleteDateObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()

                }
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    class func getWorkoutCompletedObjects(session: NSString, routine: NSString, workout: NSString, index: NSNumber) -> [WorkoutCompleteDate] {
        
        let tempWorkoutCompleteArray = [WorkoutCompleteDate]()
        
        let request = NSFetchRequest( entityName: "WorkoutCompleteDate")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@",
                                 session,
                                 routine,
                                 workout,
                                 index)
        
        request.predicate = filter
        
        do {
            if let workoutCompleteDateObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [WorkoutCompleteDate] {
                
                print("workoutCompleteDateObjects.count = \(workoutCompleteDateObjects.count)")
                
                return workoutCompleteDateObjects
                
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return tempWorkoutCompleteArray
    }
    
    class func deleteDate(session: NSString, routine: NSString, workout: NSString, index: NSNumber) {
        
        let request = NSFetchRequest( entityName: "WorkoutCompleteDate")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@",
                                 session,
                                 routine,
                                 workout,
                                 index)
        
        request.predicate = filter
        
        do {
            if let workoutCompleteDateObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [WorkoutCompleteDate] {
                
                print("workoutCompleteDateObjects.count = \(workoutCompleteDateObjects.count)")
                
                if workoutCompleteDateObjects.count != 0 {
                    
                    for object in workoutCompleteDateObjects {
                        
                        // Delete all date records for the index.
                        CDHelper.shared.context.deleteObject(object)
                    }
                    CDHelper.saveSharedContext()

                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
}
