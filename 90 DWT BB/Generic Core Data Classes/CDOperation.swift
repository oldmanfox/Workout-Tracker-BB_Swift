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
    
    class func saveWeightWithPredicate(session: String, routine: String, workout: String, week: String, exercise: String, index: NSNumber, weight: String, round: NSNumber, reps: String) {
        
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
                    insertWorkoutInfo.week = week
                    insertWorkoutInfo.exercise = exercise
                    insertWorkoutInfo.round = round
                    insertWorkoutInfo.index = index
                    insertWorkoutInfo.weight = weight
                    insertWorkoutInfo.reps = reps
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
    
    class func saveNoteWithPredicate(session: String, routine: String, workout: String, week: String, exercise: String, index: NSNumber, note: String, round: NSNumber) {
        
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
                    insertWorkoutInfo.week = week
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
    
    class func saveNoteWithPredicateNoExercise(session: String, routine: String, workout: String, week: String, index: NSNumber, note: String, round: NSNumber) {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortRound = NSSortDescriptor( key: "round", ascending: true)
        let sortExercise = NSSortDescriptor(key: "exercise", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortWorkout = NSSortDescriptor(key: "workout", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortWorkout, sortExercise, sortRound]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@ AND round == %@",
                                 session,
                                 routine,
                                 workout,
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
                    insertWorkoutInfo.week = week
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
    
    class func getNotesTextForRound(session: String, routine: String, workout: String, round: NSNumber, index: NSNumber) -> String? {
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@ AND round = %@",
                                 session,
                                 routine,
                                 workout,
                                 index,
                                 round)
        
        request.predicate = filter
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                switch workoutObjects.count {
                case 0:
                    // No matches for this object.
                    
                    return ""
                    
                case 1:
                    let matchedWorkoutInfo = workoutObjects[0]
                    
                    return matchedWorkoutInfo.notes
                    
                default:
                    // More than one match
                    // Sort by most recent date and pick the newest
                    print("More than one match for object")
                    let matchedWorkoutInfo = workoutObjects.last
                    
                    return matchedWorkoutInfo!.notes
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return ""
    }
    
    class func getNoteObjects(session: NSString, routine: NSString, workout: NSString, index: NSNumber) -> [Workout] {
        
        let tempWorkoutCompleteArray = [Workout]()
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index = %@",
                                 session,
                                 routine,
                                 workout,
                                 index)
        
        request.predicate = filter
        
        do {
            if let workoutNoteObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                print("workoutNoteObjects.count = \(workoutNoteObjects.count)")
                
                return workoutNoteObjects
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return tempWorkoutCompleteArray
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
    
    class func getMeasurementObjects(session: NSString, month: NSString) -> [NSManagedObject] {
        
        let request = NSFetchRequest( entityName: "Measurement")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND month == %@",
                                 session,
                                 month)
        
        request.predicate = filter
        
        do {
            if let measurementObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Measurement] {
                
                print("measurementObjects.count = \(measurementObjects.count)")
                
                return measurementObjects
                
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return []
    }
    
    class func saveMeasurements(session: String, month: String, weight: String, chest: String, waist: String, hips: String, leftArm: String, rightArm: String, leftThigh: String, rightThigh: String) {
        
        let request = NSFetchRequest( entityName: "Measurement")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND month == %@",
                                 session,
                                 month)
        
        request.predicate = filter
        
        do {
            if let measurementObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Measurement] {
                
                print("measurementObjects.count = \(measurementObjects.count)")
                
                switch measurementObjects.count {
                case 0:
                    // No matches for this object.
                    // Insert a new record
                    print("No Matches")
                    let insertWorkoutInfo = NSEntityDescription.insertNewObjectForEntityForName("Measurement", inManagedObjectContext: CDHelper.shared.context) as! Measurement
                    
                    insertWorkoutInfo.session = session
                    insertWorkoutInfo.month = month
                    insertWorkoutInfo.date = NSDate()
                    
                    if weight != "" {
                        insertWorkoutInfo.weight = weight
                    }
                    
                    if chest != "" {
                        insertWorkoutInfo.chest = chest
                    }
                    
                    if waist != "" {
                        insertWorkoutInfo.waist = waist
                    }
                    
                    if hips != "" {
                        insertWorkoutInfo.hips = hips
                    }
                    
                    if leftArm != "" {
                        insertWorkoutInfo.leftArm = leftArm
                    }
                    
                    if rightArm != "" {
                        insertWorkoutInfo.rightArm = rightArm
                    }
                    
                    if leftThigh != "" {
                        insertWorkoutInfo.leftThigh = leftThigh
                    }
                    
                    if rightThigh != "" {
                        insertWorkoutInfo.rightThigh = rightThigh
                    }
                    
                    CDHelper.saveSharedContext()
                    
                case 1:
                    // Update existing record
                    
                    let updateWorkoutInfo = measurementObjects[0]
                    
                    updateWorkoutInfo.session = session
                    updateWorkoutInfo.month = month
                    updateWorkoutInfo.date = NSDate()
                    
                    if weight != "" {
                        updateWorkoutInfo.weight = weight
                    }
                    
                    if chest != "" {
                        updateWorkoutInfo.chest = chest
                    }
                    
                    if waist != "" {
                        updateWorkoutInfo.waist = waist
                    }
                    
                    if hips != "" {
                        updateWorkoutInfo.hips = hips
                    }
                    
                    if leftArm != "" {
                        updateWorkoutInfo.leftArm = leftArm
                    }
                    
                    if rightArm != "" {
                        updateWorkoutInfo.rightArm = rightArm
                    }
                    
                    if leftThigh != "" {
                        updateWorkoutInfo.leftThigh = leftThigh
                    }
                    
                    if rightThigh != "" {
                        updateWorkoutInfo.rightThigh = rightThigh
                    }
                    
                    CDHelper.saveSharedContext()
                    
                default:
                    // More than one match
                    // Sort by most recent date and delete all but the newest
                    print("More than one match for object")
                    for index in 0..<measurementObjects.count {
                        
                        if (index == measurementObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            let updateWorkoutInfo = measurementObjects[index]
                            
                            updateWorkoutInfo.session = session
                            updateWorkoutInfo.month = month
                            updateWorkoutInfo.date = NSDate()
                            
                            if weight != "" {
                                updateWorkoutInfo.weight = weight
                            }
                            
                            if chest != "" {
                                updateWorkoutInfo.chest = chest
                            }
                            
                            if waist != "" {
                                updateWorkoutInfo.waist = waist
                            }
                            
                            if hips != "" {
                                updateWorkoutInfo.hips = hips
                            }
                            
                            if leftArm != "" {
                                updateWorkoutInfo.leftArm = leftArm
                            }
                            
                            if rightArm != "" {
                                updateWorkoutInfo.rightArm = rightArm
                            }
                            
                            if leftThigh != "" {
                                updateWorkoutInfo.leftThigh = leftThigh
                            }
                            
                            if rightThigh != "" {
                                updateWorkoutInfo.rightThigh = rightThigh
                            }
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(measurementObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                }
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }

    class func loadWorkoutNameArray() -> [[String]] {
        
        switch getCurrentRoutine() {
        case "Bulk":
            // BUILD
            let build_Week1_WorkoutNameArray = ["B1: Chest+Tri",
                                                "B1: Legs",
                                                "B1: Back+Bi",
                                                "B1: Shoulders",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout",
                                                "Rest",
                                                "B1: Chest+Tri",
                                                "T1: Chest+Tri"]
            
            let build_Week2_WorkoutNameArray = ["B1: Legs",
                                                "B1: Back+Bi",
                                                "T1: Back+Bi",
                                                "B1: Shoulders",
                                                "B3: Ab Workout",
                                                "Rest",
                                                "B1: Chest+Tri",
                                                "T1: Chest+Tri",
                                                "B1: Legs",
                                                "B1: Back+Bi",
                                                "T1: Back+Bi"]
            
            let build_Week3_WorkoutNameArray = ["B1: Shoulders",
                                                "B3: Ab Workout",
                                                "Rest",
                                                "B1: Chest+Tri",
                                                "T1: Chest+Tri",
                                                "B1: Legs",
                                                "B1: Back+Bi",
                                                "T1: Back+Bi",
                                                "B1: Shoulders",
                                                "B3: Ab Workout",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout"]
            
            let build_Week4_WorkoutNameArray = ["B2: Chest",
                                                "B2: Legs",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders",
                                                "Rest",
                                                "B2: Chest"]
            
            let build_Week5_WorkoutNameArray = ["B2: Legs",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders",
                                                "Rest",
                                                "B2: Chest",
                                                "B2: Legs"]
            
            let build_Week6_WorkoutNameArray = ["B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders",
                                                "Rest",
                                                "B2: Chest",
                                                "B2: Legs",
                                                "B2: Back"]
            
            let build_Week7_WorkoutNameArray = ["B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders",
                                                "Rest",
                                                "B2: Chest",
                                                "B2: Legs",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout"]
            
            let build_Week8_WorkoutNameArray = ["B2: Shoulders",
                                                "Rest",
                                                "B2: Chest",
                                                "B2: Legs",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders"]
            
            let build_Week9_WorkoutNameArray = ["Rest",
                                                "B2: Chest",
                                                "B2: Legs",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Ab Workout",
                                                "B2: Shoulders",
                                                "Rest"]
            
            let build_Week10_WorkoutNameArray = ["B1: Chest+Tri",
                                                 "T1: Chest+Tri",
                                                 "B2: Legs",
                                                 "B1: Back+Bi",
                                                 "T1: Back+Bi",
                                                 "B3: Cardio",
                                                 "B3: Complete Body",
                                                 "B3: Ab Workout",
                                                 "Rest",
                                                 "B2: Arms",
                                                 "B1: Shoulders"]
            
            let build_Week11_WorkoutNameArray = ["B2: Chest",
                                                 "B1: Legs",
                                                 "B3: Cardio",
                                                 "B3: Complete Body",
                                                 "B3: Ab Workout",
                                                 "Rest",
                                                 "B2: Back",
                                                 "B2: Arms",
                                                 "B3: Ab Workout",
                                                 "B3: Cardio",
                                                 "B3: Complete Body"]
            
            let build_Week12_WorkoutNameArray = ["B1: Chest+Tri",
                                                 "T1: Chest+Tri",
                                                 "B2: Legs",
                                                 "B3: Cardio",
                                                 "B3: Complete Body",
                                                 "B3: Ab Workout",
                                                 "Rest",
                                                 "B1: Back+Bi",
                                                 "T1: Back+Bi",
                                                 "B2: Shoulders",
                                                 "B3: Cardio",
                                                 "B3: Complete Body",
                                                 "B3: Ab Workout"]
            
            let build_WorkoutNameArray = [build_Week1_WorkoutNameArray,
                                          build_Week2_WorkoutNameArray,
                                          build_Week3_WorkoutNameArray,
                                          build_Week4_WorkoutNameArray,
                                          build_Week5_WorkoutNameArray,
                                          build_Week6_WorkoutNameArray,
                                          build_Week7_WorkoutNameArray,
                                          build_Week8_WorkoutNameArray,
                                          build_Week9_WorkoutNameArray,
                                          build_Week10_WorkoutNameArray,
                                          build_Week11_WorkoutNameArray,
                                          build_Week12_WorkoutNameArray]
            
            return build_WorkoutNameArray
            
        default:
            // TONE
            let tone_Week1_WorkoutNameArray = ["B1: Chest+Tri",
                                               "B1: Legs",
                                               "B1: Back+Bi",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B1: Shoulders",
                                               "Rest",
                                               "B1: Chest+Tri",
                                               "T1: Chest+Tri"]
            
            let tone_Week2_WorkoutNameArray = ["B1: Legs",
                                               "B1: Back+Bi",
                                               "T1: Back+Bi",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B1: Shoulders",
                                               "Rest",
                                               "B1: Chest+Tri",
                                               "T1: Chest+Tri",
                                               "B1: Legs"]
            
            let tone_Week3_WorkoutNameArray = ["B1: Back+Bi",
                                               "T1: Back+Bi",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B1: Shoulders",
                                               "Rest",
                                               "B1: Chest+Tri",
                                               "T1: Chest+Tri",
                                               "B1: Legs",
                                               "B1: Back+Bi",
                                               "T1: Back+Bi"]
            
            let tone_Week4_WorkoutNameArray = ["B2: Chest",
                                               "B2: Legs",
                                               "B2: Arms",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B2: Back",
                                               "B2: Shoulders",
                                               "Rest"]
            
            let tone_Week5_WorkoutNameArray = ["B2: Chest",
                                               "B2: Legs",
                                               "B2: Arms",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B2: Back",
                                               "B2: Shoulders",
                                               "Rest"]
            
            let tone_Week6_WorkoutNameArray = ["B2: Chest",
                                               "B2: Legs",
                                               "B2: Arms",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B2: Back",
                                               "B2: Shoulders",
                                               "Rest"]
            
            let tone_Week7_WorkoutNameArray = ["B2: Chest",
                                               "B2: Legs",
                                               "B2: Arms",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B2: Back",
                                               "B2: Shoulders",
                                               "Rest"]
            
            let tone_Week8_WorkoutNameArray = ["B2: Chest",
                                               "B2: Legs",
                                               "B2: Arms",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B2: Back",
                                               "B2: Shoulders",
                                               "Rest"]
            
            let tone_Week9_WorkoutNameArray = ["B1: Chest+Tri",
                                               "T1: Chest+Tri",
                                               "B2: Legs",
                                               "B1: Back+Bi",
                                               "T1: Back+Bi",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout",
                                               "B1: Shoulders",
                                               "Rest",
                                               "B3: Cardio",
                                               "B3: Complete Body",
                                               "B3: Ab Workout"]
            
            let tone_Week10_WorkoutNameArray = ["B2: Chest",
                                                "B1: Legs",
                                                "B2: Shoulders",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout",
                                                "Rest"]
            
            let tone_Week11_WorkoutNameArray = ["B1: Chest+Tri",
                                                "T1: Chest+Tri",
                                                "B2: Legs",
                                                "B1: Back+Bi",
                                                "T1: Back+Bi",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout",
                                                "B1: Shoulders",
                                                "Rest",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout"]
            
            let tone_Week12_WorkoutNameArray = ["B2: Chest",
                                                "B1: Legs",
                                                "B2: Shoulders",
                                                "B2: Back",
                                                "B2: Arms",
                                                "B3: Cardio",
                                                "B3: Complete Body",
                                                "B3: Ab Workout",
                                                "Rest"]
            
            let tone_WorkoutNameArray = [tone_Week1_WorkoutNameArray,
                                         tone_Week2_WorkoutNameArray,
                                         tone_Week3_WorkoutNameArray,
                                         tone_Week4_WorkoutNameArray,
                                         tone_Week5_WorkoutNameArray,
                                         tone_Week6_WorkoutNameArray,
                                         tone_Week7_WorkoutNameArray,
                                         tone_Week8_WorkoutNameArray,
                                         tone_Week9_WorkoutNameArray,
                                         tone_Week10_WorkoutNameArray,
                                         tone_Week11_WorkoutNameArray,
                                         tone_Week12_WorkoutNameArray]

            return tone_WorkoutNameArray
        }
    }
    
    class func loadWorkoutIndexArray() -> [[Int]] {
        
        switch getCurrentRoutine() {
        case "Bulk":
            // BUILD
            let build_Week1_WorkoutIndexArray = [1,
                                                 1,
                                                 1,
                                                 1,
                                                 1,
                                                 1,
                                                 1,
                                                 1,
                                                 2,
                                                 1]
            
            let build_Week2_WorkoutIndexArray = [2,
                                                 2,
                                                 1,
                                                 2,
                                                 2,
                                                 2,
                                                 3,
                                                 2,
                                                 3,
                                                 3,
                                                 2]
            
            let build_Week3_WorkoutIndexArray = [3,
                                                 3,
                                                 3,
                                                 4,
                                                 3,
                                                 4,
                                                 4,
                                                 3,
                                                 4,
                                                 4,
                                                 2,
                                                 2,
                                                 5]
            
            let build_Week4_WorkoutIndexArray = [1,
                                                 1,
                                                 1,
                                                 1,
                                                 6,
                                                 1,
                                                 4,
                                                 2]
            
            let build_Week5_WorkoutIndexArray = [2,
                                                 2,
                                                 2,
                                                 7,
                                                 2,
                                                 5,
                                                 3,
                                                 3]
            
            let build_Week6_WorkoutIndexArray = [3,
                                                 3,
                                                 8,
                                                 3,
                                                 6,
                                                 4,
                                                 4,
                                                 4]
            
            let build_Week7_WorkoutIndexArray = [4,
                                                 9,
                                                 4,
                                                 7,
                                                 5,
                                                 5,
                                                 5,
                                                 5,
                                                 10]
            
            let build_Week8_WorkoutIndexArray = [5,
                                                 8,
                                                 6,
                                                 6,
                                                 6,
                                                 6,
                                                 11,
                                                 6]
            
            let build_Week9_WorkoutIndexArray = [9,
                                                 7,
                                                 7,
                                                 7,
                                                 7,
                                                 12,
                                                 7,
                                                 10]
            
            let build_Week10_WorkoutIndexArray = [5,
                                                  4,
                                                  8,
                                                  5,
                                                  4,
                                                  3,
                                                  3,
                                                  13,
                                                  11,
                                                  8,
                                                  5]
            
            let build_Week11_WorkoutIndexArray = [8,
                                                  5,
                                                  4,
                                                  4,
                                                  14,
                                                  12,
                                                  8,
                                                  9,
                                                  15,
                                                  5,
                                                  5]
            
            let build_Week12_WorkoutIndexArray = [6,
                                                  5,
                                                  9,
                                                  6,
                                                  6,
                                                  16,
                                                  13,
                                                  6,
                                                  5,
                                                  8,
                                                  7,
                                                  7,
                                                  17]
            
            let build_WorkoutIndexArray = [build_Week1_WorkoutIndexArray,
                                           build_Week2_WorkoutIndexArray,
                                           build_Week3_WorkoutIndexArray,
                                           build_Week4_WorkoutIndexArray,
                                           build_Week5_WorkoutIndexArray,
                                           build_Week6_WorkoutIndexArray,
                                           build_Week7_WorkoutIndexArray,
                                           build_Week8_WorkoutIndexArray,
                                           build_Week9_WorkoutIndexArray,
                                           build_Week10_WorkoutIndexArray,
                                           build_Week11_WorkoutIndexArray,
                                           build_Week12_WorkoutIndexArray]
            
            return build_WorkoutIndexArray

        default:
            // TONE
            let tone_Week1_WorkoutIndexArray = [1,
                                                1,
                                                1,
                                                1,
                                                1,
                                                1,
                                                1,
                                                1,
                                                2,
                                                1]
            
            let tone_Week2_WorkoutIndexArray = [2,
                                                2,
                                                1,
                                                2,
                                                2,
                                                2,
                                                2,
                                                2,
                                                3,
                                                2,
                                                3]
            
            let tone_Week3_WorkoutIndexArray = [3,
                                                2,
                                                3,
                                                3,
                                                3,
                                                3,
                                                3,
                                                4,
                                                3,
                                                4,
                                                4,
                                                3]
            
            let tone_Week4_WorkoutIndexArray = [1,
                                                1,
                                                1,
                                                4,
                                                4,
                                                4,
                                                1,
                                                1,
                                                4]
            
            let tone_Week5_WorkoutIndexArray = [2,
                                                2,
                                                2,
                                                5,
                                                5,
                                                5,
                                                2,
                                                2,
                                                5]
            
            let tone_Week6_WorkoutIndexArray = [3,
                                                3,
                                                3,
                                                6,
                                                6,
                                                6,
                                                3,
                                                3,
                                                6]
            
            let tone_Week7_WorkoutIndexArray = [4,
                                                4,
                                                4,
                                                7,
                                                7,
                                                7,
                                                4,
                                                4,
                                                7]
            
            let tone_Week8_WorkoutIndexArray = [5,
                                                5,
                                                5,
                                                8,
                                                8,
                                                8,
                                                5,
                                                5,
                                                8]
            
            let tone_Week9_WorkoutIndexArray = [5,
                                                4,
                                                6,
                                                5,
                                                4,
                                                9,
                                                9,
                                                9,
                                                4,
                                                9,
                                                10,
                                                10,
                                                10]
            
            let tone_Week10_WorkoutIndexArray = [6,
                                                 5,
                                                 6,
                                                 6,
                                                 6,
                                                 11,
                                                 11,
                                                 11,
                                                 10]
            
            let tone_Week11_WorkoutIndexArray = [6,
                                                 5,
                                                 7,
                                                 6,
                                                 5,
                                                 12,
                                                 12,
                                                 12,
                                                 5,
                                                 11,
                                                 13,
                                                 13,
                                                 13]
            
            let tone_Week12_WorkoutIndexArray = [7,
                                                 6,
                                                 7,
                                                 7,
                                                 7,
                                                 14,
                                                 14,
                                                 14,
                                                 12]
            
            let tone_WorkoutIndexArray = [tone_Week1_WorkoutIndexArray,
                                          tone_Week2_WorkoutIndexArray,
                                          tone_Week3_WorkoutIndexArray,
                                          tone_Week4_WorkoutIndexArray,
                                          tone_Week5_WorkoutIndexArray,
                                          tone_Week6_WorkoutIndexArray,
                                          tone_Week7_WorkoutIndexArray,
                                          tone_Week8_WorkoutIndexArray,
                                          tone_Week9_WorkoutIndexArray,
                                          tone_Week10_WorkoutIndexArray,
                                          tone_Week11_WorkoutIndexArray,
                                          tone_Week12_WorkoutIndexArray]
            
            return tone_WorkoutIndexArray
        }
    }
    
    class func allWorkoutTitleArray() -> [String] {
        
        let workoutTitleArray = ["B1: Back+Bi",
                                 "B1: Chest+Tri",
                                 "B1: Legs",
                                 "B1: Shoulders",
                                 "B2: Arms",
                                 "B2: Back",
                                 "B2: Chest",
                                 "B2: Legs",
                                 "B2: Shoulders",
                                 "B3: Ab Workout",
                                 "B3: Cardio",
                                 "B3: Complete Body",
                                 "T1: Back+Bi",
                                 "T1: Chest+Tri",
                                 "Rest"]
        
        return workoutTitleArray
    }
    
    class func allExerciseTitleArray() -> [[String]] {
        
        // Get all the exercise names for each workout
        
        let b1_Back_Bi = ["Dumbbell Deadlift",
                          "Dumbbell Pull-Over",
                          "Pull-Up",
                          "Curl Bar Row",
                          "One-Arm Dumbbell Row",
                          "Reverse Fly",
                          "Close-Grip Chin-Up",
                          "Seated Bicep Curl",
                          "Hammer Curl",
                          "Curl Bar Bicep Curl",
                          "Superman to Airplane"]

        let b1_Chest_Tri = ["Dumbbell Chest Press",
                            "Incline Dumbbell Fly",
                            "Incline Dumbbell Press",
                            "Close Grip Dumbbell Press",
                            "Partial Dumbbell Fly",
                            "Decline Push-Up",
                            "Laying Tricep Extension",
                            "Single Arm Tricep Kickback",
                            "Diamond Push-Up",
                            "Dips",
                            "Abs"]
        
        let b1_Legs = ["Wide Squat",
                       "Alt Lunge",
                       "S-U to Reverse Lunge",
                       "P Squat",
                       "B Squat",
                       "S-L Deadlift",
                       "S-L Calf Raise",
                       "S Calf Raise",
                       "Abs"]
        
        let b1_Shoulders = ["Dumbbell Shoulder Press",
                            "Dumbbell Lateral Raise",
                            "Curl Bar Upright Row",
                            "Curl Bar Underhand Press",
                            "Front Raise",
                            "Rear Fly",
                            "Dumbbell Shrug",
                            "Leaning Dumbbell Shrug",
                            "6-Way Shoulder",
                            "Abs"]
        
        let b2_Arms = ["Dumbbell Curl",
                       "Seated Dumbbell Tricep Extension",
                       "Curl Bar Curl",
                       "Laying Curl Bar Tricep Extension",
                       "Dumbbell Hammer Curl",
                       "Leaning Dumbbell Tricep Extension",
                       "Abs"]
        
        let b2_Back = ["Dumbbell Pull-Over",
                       "Pull-Up",
                       "Curl Bar Underhand Row",
                       "One Arm Dumbbell Row",
                       "Deadlift",
                       "Reverse Fly",
                       "Plank Row Arm Balance"]
        
        let b2_Chest = ["Incline Dumbbell Fly",
                        "Incline Dumbbell Press 1",
                        "Rotating Dumbbell Chest Press",
                        "Incline Dumbbell Press 2",
                        "Center Dumbbell Chest Press Fly",
                        "Decline Push-Up",
                        "Superman Airplane",
                        "Russian Twist"]

        let b2_Legs = ["2-Way Lunge",
                       "Dumbbell Squat",
                       "2-Way Sumo Squat",
                       "Curl Bar Split Squat",
                       "S-L Deadlift",
                       "Side to Side Squat",
                       "S-L Calf Raise",
                       "Abs"]
        
        let b2_Shoulders = ["Dumbbell Lateral Raise",
                            "Dumbbell Arnold Press",
                            "Curl Bar Upright Row",
                            "One Arm Dumbbell Front Raise",
                            "Two Arm Front Raise Rotate",
                            "Reverse Fly",
                            "Plank Opposite Arm Leg Raise",
                            "Plank Crunch"]
        
        let b3_Ab_Workout = [String]()
        
        let b3_Cardio = [String]()
        
        let b3_Complete_Body = ["Pull-Up",
                                "Push-Up",
                                "Dumbbell Squat",
                                "Crunch",
                                "Dumbell Incline Press",
                                "Dumbell Bent-Over Row",
                                "Dumbell Alt Reverse Lunge",
                                "Plank Crunch",
                                "3-Way Military Press",
                                "Single Arm Leaning Reverse Fly",
                                "S-L Deadlift",
                                "Russian Twist",
                                "Curl-Up Hammer-Down",
                                "Leaning Tricep Extension",
                                "Calf Raise",
                                "Side Sphinx Raise"]

        let t1_Back_Bi = ["Dumbbell Pull-Over",
                          "Plank Hop",
                          "Pull-Up",
                          "Hanging Side-To-Side Crunch",
                          "Curl Bar Row",
                          "Curl Bar Twist",
                          "Dumbbell Preacher Curl",
                          "Hanging Crunch",
                          "Curl Bar Multi Curl",
                          "Mountain Climber"]
        
        let t1_Chest_Tri = ["Dumbbell Chest Press",
                            "Crunch 1",
                            "Incline Dumbbell Press",
                            "Crunch 2",
                            "Incline Dumbbell Fly",
                            "Plank To Sphinx",
                            "Curl Bar Tricep Extension",
                            "Curl Bar Crunch",
                            "Dumbbell Tricep Extension",
                            "Dips",
                            "Plank Crunch"]
        
        let rest = [String]()

        let exerciseTitleArray = [b1_Back_Bi,
                                  b1_Chest_Tri,
                                  b1_Legs,
                                  b1_Shoulders,
                                  b2_Arms,
                                  b2_Back,
                                  b2_Chest,
                                  b2_Legs,
                                  b2_Shoulders,
                                  b3_Ab_Workout,
                                  b3_Cardio,
                                  b3_Complete_Body,
                                  t1_Back_Bi,
                                  t1_Chest_Tri,
                                  rest]
        
        return exerciseTitleArray
    }
    
    class func allSessionStringForEmail() -> String {
        
        // Get Data from the database.
        let allWorkoutTitlesArray = self.allWorkoutTitleArray()
        let allExerciseTitlesArray = self.allExerciseTitleArray()
        let writeString = NSMutableString()
        
        let routineArray = ["Bulk",
                             "Tone"]
        
        // Get the highest session value stored in the database
        let maxSession = Int(self.findMaxSessionValue())
        
        // For each session, list each workouts data.  Bulk then tone.
        for sessionCounter in 1...maxSession! {
            
            // Get session value.
            let currentSessionString = String(sessionCounter)
            
            // Routine
            for routineIndex in 0..<routineArray.count {
                
                // Workout
                for i in 0..<allWorkoutTitlesArray.count {
                    
                    let tempExerciseTitlesArray = allExerciseTitlesArray[i]
                    
                    // Get workout data with the current session.  Sort by INDEX.
                    let request = NSFetchRequest( entityName: "Workout")
                    let sortIndex = NSSortDescriptor( key: "index", ascending: true)
                    let sortDate = NSSortDescriptor( key: "date", ascending: true)
                    request.sortDescriptors = [sortIndex, sortDate]
                    
                    let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@",
                                             currentSessionString,
                                             routineArray[routineIndex],
                                             allWorkoutTitlesArray[i])
                    
                    request.predicate = filter
                    
                    do {
                        if let workoutObjects1 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                            
                            print("workoutObjects1.count = \(workoutObjects1.count)")
                            
                            var maxIndex = 0
                            
                            if workoutObjects1.count != 0 {
                                
                                maxIndex = Int((workoutObjects1.last?.index)!)
                                
                                var localSession = ""
                                var localRoutine = ""
                                var localWeek = ""
                                var localWorkout = ""
                                var localDate = NSDate()
                                var dateString = ""
                                
                                var tempExerciseName = ""
                                var tempWeightData = ""
                                var tempRepData = ""
                                var roundConverted = NSNumber()
                                
                                // Get the values for each index that was found for this workout
                                for index in 1...maxIndex {
                                    
                                    let convertedIndex = NSNumber(integer: index)
                                    
                                    // Get workout data with workout index
                                    let request = NSFetchRequest( entityName: "Workout")
                                    
                                    var filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index == %@",
                                                             currentSessionString,
                                                             routineArray[routineIndex],
                                                             allWorkoutTitlesArray[i],
                                                             convertedIndex)
                                    
                                    request.predicate = filter
                                    
                                    do {
                                        if let workoutObjects2 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                            
                                            //print("workoutObjects.count = \(workoutObjects.count)")
                                            
                                            // Check if there are any matches for the given index.  If none skip the index.
                                            if workoutObjects2.count == 0 {
                                                
                                                // No Matches for this workout with index
                                            }
                                            else {
                                                
                                                // Matches found
                                                
                                                // Add column headers
                                                for a in 0..<1 {
                                                    
                                                    //  Add the column headers for Routine, Month, Week, Workout, and Date to the string
                                                    writeString.appendString("Session,Routine,Week,Try,Workout,Date\n")
                                                    
                                                    localSession = workoutObjects2[a].session!
                                                    localRoutine = workoutObjects2[a].routine!
                                                    localWeek = workoutObjects2[a].week!
                                                    localWorkout = workoutObjects2[a].workout!
                                                    localDate = workoutObjects2[a].date!
                                                    
                                                    dateString = NSDateFormatter.localizedStringFromDate(localDate, dateStyle: .ShortStyle, timeStyle: .NoStyle)
                                                    
                                                    // Add column headers for indivialual workouts based on workout index number
                                                    writeString.appendString("\(localSession),\(localRoutine),\(localWeek),\(index),\(localWorkout),\(dateString)\n")
                                                }
                                                
                                                let workoutIndex = NSNumber(integer: index)
                                                
                                                //  Add the exercise name, reps and weight
                                                for b in 0..<tempExerciseTitlesArray.count {
                                                    
                                                    tempExerciseName = tempExerciseTitlesArray[b]
                                                    
                                                    //  Add the exercise title to the string
                                                    writeString.appendString("\(tempExerciseName)\n")
                                                    
                                                    //  Add the reps to the string
                                                    for round in 0..<6 {
                                                        
                                                        roundConverted = NSNumber(integer: round)
                                                        tempRepData = ""
                                                        
                                                        filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise = %@ AND round = %@ AND index == %@",
                                                                             currentSessionString,
                                                                             localRoutine,
                                                                             localWorkout,
                                                                             tempExerciseName,
                                                                             roundConverted,
                                                                             workoutIndex)
                                                        
                                                        request.predicate = filter
                                                        
                                                        do {
                                                            if let workoutObjects3 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                                                
                                                                //print("workoutObjects.count = \(workoutObjects.count)")
                                                                
                                                                if workoutObjects3.count >= 1 {
                                                                    
                                                                    //  Match found
                                                                    if workoutObjects3.last?.reps != nil {
                                                                        
                                                                        tempRepData = (workoutObjects3.last?.reps)!
                                                                        
                                                                        if round == 5 {
                                                                            //  Last column in the row so end the line with a return mark \n
                                                                            writeString.appendString("\(tempRepData)\n")
                                                                        }
                                                                        else {
                                                                            
                                                                            writeString.appendString("\(tempRepData),")
                                                                        }
                                                                    }
                                                                }
                                                                else {
                                                                    
                                                                    if round == 5 {
                                                                        
                                                                        //  Inserts a "" into the string and ends the line with a return mark \n
                                                                        writeString.appendString("\(tempRepData)\n")
                                                                    }
                                                                    else {
                                                                        
                                                                        //  Inserts a "" into the string
                                                                        writeString.appendString("\(tempRepData),")
                                                                    }
                                                                }
                                                            }
                                                        } catch { print(" ERROR executing a fetch request: \( error)") }
                                                    }
                                                    
                                                    //  Add the weight line from the database
                                                    for round in 0..<6 {
                                                        
                                                        roundConverted = NSNumber(integer: round)
                                                        tempWeightData = ""
                                                        
                                                        filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise = %@ AND round = %@ AND index == %@",
                                                                             currentSessionString,
                                                                             localRoutine,
                                                                             localWorkout,
                                                                             tempExerciseName,
                                                                             roundConverted,
                                                                             workoutIndex)
                                                        
                                                        request.predicate = filter
                                                        
                                                        do {
                                                            if let workoutObjects4 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                                                
                                                                //print("workoutObjects.count = \(workoutObjects.count)")
                                                                
                                                                if workoutObjects4.count >= 1 {
                                                                    
                                                                    //  Match found
                                                                    if workoutObjects4.last?.weight != nil {
                                                                        
                                                                        tempWeightData = (workoutObjects4.last?.weight)!
                                                                        
                                                                        if round == 5 {
                                                                            //  Last column in the row so end the line with a return mark \n
                                                                            writeString.appendString("\(tempWeightData)\n")
                                                                        }
                                                                        else {
                                                                            
                                                                            writeString.appendString("\(tempWeightData),")
                                                                        }
                                                                    }
                                                                }
                                                                else {
                                                                    
                                                                    if round == 5 {
                                                                        
                                                                        //  Inserts a "" into the string and ends the line with a return mark \n
                                                                        writeString.appendString("\(tempWeightData)\n")
                                                                    }
                                                                    else {
                                                                        
                                                                        //  Inserts a "" into the string
                                                                        writeString.appendString("\(tempWeightData),")
                                                                    }
                                                                }
                                                            }
                                                        } catch { print(" ERROR executing a fetch request: \( error)") }
                                                    }
                                                }
                                            }
                                        }
                                    } catch { print(" ERROR executing a fetch request: \( error)") }
                                }
                            }
                        }
                    } catch { print(" ERROR executing a fetch request: \( error)") }
                }
            }
        }
        
        //  Return the string
        return writeString as String
    }
    
    class func currentSessionStringForEmail() -> String {
        
        // Get Data from the database.
        let allWorkoutTitlesArray = self.allWorkoutTitleArray()
        let allExerciseTitlesArray = self.allExerciseTitleArray()
        let writeString = NSMutableString()
        
        let routineArray = ["Bulk",
                            "Tone"]
        
        // Get the current session value stored in the database
        let currentSessionString = self.getCurrentSession()
        
        // Routine
        for routineIndex in 0..<routineArray.count {
            
            // Workout
            for i in 0..<allWorkoutTitlesArray.count {
                
                let tempExerciseTitlesArray = allExerciseTitlesArray[i]
                
                // Get workout data with the current session.  Sort by INDEX.
                let request = NSFetchRequest( entityName: "Workout")
                let sortIndex = NSSortDescriptor( key: "index", ascending: true)
                let sortDate = NSSortDescriptor( key: "date", ascending: true)
                request.sortDescriptors = [sortIndex, sortDate]
                
                let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@",
                                         currentSessionString,
                                         routineArray[routineIndex],
                                         allWorkoutTitlesArray[i])
                
                request.predicate = filter
                
                do {
                    if let workoutObjects1 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                        
                        print("workoutObjects1.count = \(workoutObjects1.count)")
                        
                        var maxIndex = 0
                        
                        if workoutObjects1.count != 0 {
                            
                            maxIndex = Int((workoutObjects1.last?.index)!)
                            
                            var localSession = ""
                            var localRoutine = ""
                            var localWeek = ""
                            var localWorkout = ""
                            var localDate = NSDate()
                            var dateString = ""
                            
                            var tempExerciseName = ""
                            var tempWeightData = ""
                            var tempRepData = ""
                            var roundConverted = NSNumber()
                            
                            // Get the values for each index that was found for this workout
                            for index in 1...maxIndex {
                                
                                let convertedIndex = NSNumber(integer: index)
                                
                                // Get workout data with workout index
                                let request = NSFetchRequest( entityName: "Workout")
                                
                                var filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index == %@",
                                                         currentSessionString,
                                                         routineArray[routineIndex],
                                                         allWorkoutTitlesArray[i],
                                                         convertedIndex)
                                
                                request.predicate = filter
                                
                                do {
                                    if let workoutObjects2 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                        
                                        //print("workoutObjects.count = \(workoutObjects.count)")
                                        
                                        // Check if there are any matches for the given index.  If none skip the index.
                                        if workoutObjects2.count == 0 {
                                            
                                            // No Matches for this workout with index
                                        }
                                        else {
                                            
                                            // Matches found
                                            
                                            // Add column headers
                                            for a in 0..<1 {
                                                
                                                //  Add the column headers for Routine, Month, Week, Workout, and Date to the string
                                                writeString.appendString("Session,Routine,Week,Try,Workout,Date\n")
                                                
                                                localSession = workoutObjects2[a].session!
                                                localRoutine = workoutObjects2[a].routine!
                                                localWeek = workoutObjects2[a].week!
                                                localWorkout = workoutObjects2[a].workout!
                                                localDate = workoutObjects2[a].date!
                                                
                                                dateString = NSDateFormatter.localizedStringFromDate(localDate, dateStyle: .ShortStyle, timeStyle: .NoStyle)
                                                
                                                // Add column headers for indivialual workouts based on workout index number
                                                writeString.appendString("\(localSession),\(localRoutine),\(localWeek),\(index),\(localWorkout),\(dateString)\n")
                                            }
                                            
                                            let workoutIndex = NSNumber(integer: index)
                                            
                                            //  Add the exercise name, reps and weight
                                            for b in 0..<tempExerciseTitlesArray.count {
                                                
                                                tempExerciseName = tempExerciseTitlesArray[b]
                                                
                                                //  Add the exercise title to the string
                                                writeString.appendString("\(tempExerciseName)\n")
                                                
                                                //  Add the reps to the string
                                                for round in 0..<6 {
                                                    
                                                    roundConverted = NSNumber(integer: round)
                                                    tempRepData = ""
                                                    
                                                    filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise = %@ AND round = %@ AND index == %@",
                                                                         currentSessionString,
                                                                         localRoutine,
                                                                         localWorkout,
                                                                         tempExerciseName,
                                                                         roundConverted,
                                                                         workoutIndex)
                                                    
                                                    request.predicate = filter
                                                    
                                                    do {
                                                        if let workoutObjects3 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                                            
                                                            //print("workoutObjects.count = \(workoutObjects.count)")
                                                            
                                                            if workoutObjects3.count >= 1 {
                                                                
                                                                //  Match found
                                                                if workoutObjects3.last?.reps != nil {
                                                                    
                                                                    tempRepData = (workoutObjects3.last?.reps)!
                                                                    
                                                                    if round == 5 {
                                                                        //  Last column in the row so end the line with a return mark \n
                                                                        writeString.appendString("\(tempRepData)\n")
                                                                    }
                                                                    else {
                                                                        
                                                                        writeString.appendString("\(tempRepData),")
                                                                    }
                                                                }
                                                            }
                                                            else {
                                                                
                                                                if round == 5 {
                                                                    
                                                                    //  Inserts a "" into the string and ends the line with a return mark \n
                                                                    writeString.appendString("\(tempRepData)\n")
                                                                }
                                                                else {
                                                                    
                                                                    //  Inserts a "" into the string
                                                                    writeString.appendString("\(tempRepData),")
                                                                }
                                                            }
                                                        }
                                                    } catch { print(" ERROR executing a fetch request: \( error)") }
                                                }
                                                
                                                //  Add the weight line from the database
                                                for round in 0..<6 {
                                                    
                                                    roundConverted = NSNumber(integer: round)
                                                    tempWeightData = ""
                                                    
                                                    filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise = %@ AND round = %@ AND index == %@",
                                                                         currentSessionString,
                                                                         localRoutine,
                                                                         localWorkout,
                                                                         tempExerciseName,
                                                                         roundConverted,
                                                                         workoutIndex)
                                                    
                                                    request.predicate = filter
                                                    
                                                    do {
                                                        if let workoutObjects4 = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                                                            
                                                            //print("workoutObjects.count = \(workoutObjects.count)")
                                                            
                                                            if workoutObjects4.count >= 1 {
                                                                
                                                                //  Match found
                                                                if workoutObjects4.last?.weight != nil {
                                                                    
                                                                    tempWeightData = (workoutObjects4.last?.weight)!
                                                                    
                                                                    if round == 5 {
                                                                        //  Last column in the row so end the line with a return mark \n
                                                                        writeString.appendString("\(tempWeightData)\n")
                                                                    }
                                                                    else {
                                                                        
                                                                        writeString.appendString("\(tempWeightData),")
                                                                    }
                                                                }
                                                            }
                                                            else {
                                                                
                                                                if round == 5 {
                                                                    
                                                                    //  Inserts a "" into the string and ends the line with a return mark \n
                                                                    writeString.appendString("\(tempWeightData)\n")
                                                                }
                                                                else {
                                                                    
                                                                    //  Inserts a "" into the string
                                                                    writeString.appendString("\(tempWeightData),")
                                                                }
                                                            }
                                                        }
                                                    } catch { print(" ERROR executing a fetch request: \( error)") }
                                                }
                                            }
                                        }
                                    }
                                } catch { print(" ERROR executing a fetch request: \( error)") }
                            }
                        }
                    }
                } catch { print(" ERROR executing a fetch request: \( error)") }
            }
        }
        
        //  Return the string
        return writeString as String
    }
    
    class func findMaxSessionValue() -> String {
        
        // Workout Entity
        let request = NSFetchRequest( entityName: "Workout")
        let sortSession = NSSortDescriptor( key: "session", ascending: true)
        
        request.sortDescriptors = [sortSession]
        
        var maxSessionString = "1"
        
        do {
            if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                maxSessionString = (workoutObjects.last?.session)!
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return maxSessionString
    }
}
