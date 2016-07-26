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
    
    class func saveWithPredicate(session: String, routine: String, workout: String, exercise: String, index: NSNumber, weight: String, round: NSNumber) {
        
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

//                switch workoutObjects.count {
//                case 0:
//                    // No matches for this object.
//                    print("No matches")
//                    return workoutObjects
//                    
//                case 1:
//                    print("1 match")
//                    
//                    return workoutObjects
//                    
//                case 6:
//                    print("6 matches")
//                    
//                    return workoutObjects
//                    
//                default:
//                    // More than one match
//                    // Sort by most recent date and pick the newest
//                    print("More than 6 matches for object")
//                    
//                    var workoutArray = [NSManagedObject]()
//                    
//                    for outerIndex in 0...5 {
//                        
//                        var objectsAtIndexArray = [NSManagedObject]()
//                        
//                        for object in workoutObjects {
//                            
//                            if object.round == outerIndex {
//                                objectsAtIndexArray.append(object)
//                            }
//                        }
//                        
//                        if objectsAtIndexArray.count != 0 {
//                            
//                            workoutArray.append(objectsAtIndexArray.last!)
//                        }
//                        
//                    }
//                    
//                    return workoutArray
//                }
//            }
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


//    class func updateWorkoutEntityForFRC() {
//        
//        struct CellType {
//            static let workout = "WorkoutCell"
//            static let completion = "CompletionCell"
//        }
//        
//        struct Reps {
//            
//            struct Number {
//                static let _5 = "5"
//                static let _8 = "8"
//                static let _10 = "10"
//                static let _12 = "12"
//                static let _15 = "15"
//                static let _30 = "30"
//                static let _50 = "50"
//                static let _60 = "60"
//                static let empty = ""
//            }
//            
//            struct Title {
//                static let reps = "Reps"
//                static let sec = "Sec"
//                static let empty = ""
//            }
//        }
//
//        
//        let workoutNameArray = ["B1: Chest+Tri",
//                                "B1: Legs",
//                                "B1: Back+Bi",
//                                "B1: Shoulders",
//                                "B2: Arms",
//                                "B2: Legs",
//                                "B2: Shoulders",
//                                "B2: Chest",
//                                "B2: Back",
//                                "T1: Chest+Tri",
//                                "T1: Back+Bi",
//                                "B3: Complete Body"]
//        
//        let bulkIndexForWorkout = [6,
//                                   5,
//                                   6,
//                                   5,
//                                   9,
//                                   9,
//                                   8,
//                                   8,
//                                   8,
//                                   5,
//                                   5,
//                                   7]
//        
//        let toneIndexForWorkout = [6,
//                                   6,
//                                   6,
//                                   5,
//                                   7,
//                                   7,
//                                   7,
//                                   7,
//                                   7,
//                                   5,
//                                   5,
//                                   14]
//    
//        var counter = 0
//        
//        for workoutNameIndex in 0..<workoutNameArray.count {
//            
//            var cellArray = [[], []]
//            
//            let workoutName = workoutNameArray[workoutNameIndex]
//            
//            switch workoutName {
//            case "B1: Chest+Tri":
//                
//                let cell1 = [["Dumbbell Chest Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell2 = [["Incline Dumbbell Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell3 = [["Incline Dumbbell Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell4 = [["Close Grip Dumbbell Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell5 = [["Partial Dumbbell Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell6 = [["Decline Push-Up"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell7 = [["Laying Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell8 = [["Single Arm Tricep Kickback"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell9 = [["Diamond Push-Up"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [CellType.workout]]
//                
//                let cell10 = [["Dips"],
//                              [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.sec, Reps.Title.empty , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [CellType.workout]]
//                
//                let cell11 = [["Abs"],
//                              [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [CellType.workout]]
//                
//                let completeCell = [["CompleteCell"],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                
//                cellArray = [[cell1],
//                             [cell2, cell3],
//                             [cell4, cell5, cell6],
//                             [cell7],
//                             [cell8, cell9],
//                             [cell10, cell11],
//                             [completeCell]]
//                
//                
//                
//                
//                
//                
//            case "B1: Legs":
//                
//                let cell1 = [["Wide Squat"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Alt Lunge"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["S-U to Reverse Lunge"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["P Squat"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["B Squat"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["S-L Deadlift"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["S-L Calf Raise"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["S Calf Raise"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["Abs"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1],
//                             [cell2, cell3],
//                             [cell4, cell5, cell6],
//                             [cell7, cell8, cell9],
//                             [completeCell]]
//                
//            case "B1: Back+Bi":
//                
//                let cell1 = [["Dumbbell Deadlift"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Dumbbell Pull-Over"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Pull-Up"],
//                             [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Curl Bar Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["One-Arm Dumbbell Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Reverse Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Close-Grip Chin-Up"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Seated Bicep Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["Hammer Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell10 = [["Curl Bar Bicep Curl"],
//                              [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, false, false, true, true],
//                              [CellType.workout]]
//                
//                let cell11 = [["Superman to Airplane"],
//                              [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1],
//                             [cell2, cell3],
//                             [cell4, cell5, cell6],
//                             [cell7],
//                             [cell8],
//                             [cell9],
//                             [cell10],
//                             [cell11],
//                             [completeCell]]
//                
//            case "B1: Shoulders":
//                
//                let cell1 = [["Dumbbell Shoulder Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Dumbbell Lateral Raise"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Curl Bar Upright Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Curl Bar Underhand Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Front Raise"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Rear Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Dumbbell Shrug"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Leaning Dumbbell Shrug"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["6-Way Shoulder"],
//                             [Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell10 = [["Abs"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1],
//                             [cell2, cell3],
//                             [cell4, cell5, cell6],
//                             [cell7, cell8],
//                             [cell9, cell10],
//                             [completeCell]]
//                
//            case "B2: Arms":
//                
//                let cell1 = [["Dumbbell Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell2 = [["Seated Dumbbell Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Curl Bar Curl"],
//                             [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                             [false, false, false, false, false, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Laying Curl Bar Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Dumbbell Hammer Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell6 = [["Leaning Dumbbell Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell7 = [["Abs"],
//                             [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1],
//                             [cell2],
//                             [cell3],
//                             [cell4],
//                             [cell5],
//                             [cell6],
//                             [cell7],
//                             [completeCell]]
//                
//            case "B2: Legs":
//                
//                let cell1 = [["2-Way Lunge"],
//                             [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Dumbbell Squat"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell3 = [["2-Way Sumo Squat"],
//                             [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                             [false, false, false, false, false, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Curl Bar Split Squat"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell5 = [["S-L Deadlift"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Side to Side Squat"],
//                             [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["S-L Calf Raise"],
//                             [Reps.Number._50, Reps.Number._50, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Abs"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1],
//                             [cell2],
//                             [cell3],
//                             [cell4],
//                             [cell5, cell6],
//                             [cell7, cell8],
//                             [completeCell]]
//                
//            case "B2: Shoulders":
//                
//                let cell1 = [["Dumbbell Lateral Raise"],
//                             [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Dumbbell Arnold Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Curl Bar Upright Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell4 = [["One Arm Dumbbell Front Raise"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Two Arm Front Raise Rotate"],
//                             [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Reverse Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell7 = [["Plank Opposite Arm Leg Raise"],
//                             [Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Plank Crunch"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2],
//                             [cell3],
//                             [cell4, cell5],
//                             [cell6],
//                             [cell7, cell8],
//                             [completeCell]]
//                
//            case "B2: Chest":
//                
//                let cell1 = [["Incline Dumbbell Fly"],
//                             [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Incline Dumbbell Press 1"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Rotating Dumbbell Chest Press"],
//                             [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                             [false, false, false, false, false, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Incline Dumbbell Press 2"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell5 = [["Center Dumbbell Chest Press Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Decline Push-Up"],
//                             [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Superman Airplane"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Russian Twist"],
//                             [Reps.Number.empty, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.empty, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [UIColor.whiteColor(), Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [true, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2],
//                             [cell3],
//                             [cell4],
//                             [cell5],
//                             [cell6, cell7, cell8],
//                             [completeCell]]
//                
//            case "B2: Back":
//                
//                let cell1 = [["Dumbbell Pull-Over"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Pull-Up"],
//                             [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Curl Bar Underhand Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                             [false, false, false, false, false, false],
//                             [CellType.workout]]
//                
//                let cell4 = [["One Arm Dumbbell Row"],
//                             [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                             [false, false, false, false, false, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Deadlift"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, false, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Reverse Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Plank Row Arm Balance"],
//                             [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2],
//                             [cell3],
//                             [cell4],
//                             [cell5],
//                             [cell6, cell7],
//                             [completeCell]]
//                
//            case "T1: Chest+Tri":
//                
//                let cell1 = [["Dumbbell Chest Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Crunch 1"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Incline Dumbbell Press"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Crunch 2"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Incline Dumbbell Fly"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Plank To Sphinx"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Curl Bar Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Curl Bar Crunch"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["Dumbbell Tricep Extension"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell10 = [["Dips"],
//                              [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, false, true, true, true],
//                              [CellType.workout]]
//                
//                let cell11 = [["Plank Crunch"],
//                              [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, true, true, true, true, true],
//                              [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2],
//                             [cell3, cell4],
//                             [cell5, cell6],
//                             [cell7, cell8],
//                             [cell9, cell10, cell11],
//                             [completeCell]]
//                
//            case "T1: Back+Bi":
//                
//                let cell1 = [["Dumbbell Pull-Over"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Plank Hop"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Pull-Up"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Hanging Side-To-Side Crunch"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Curl Bar Row"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Curl Bar Twist"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Dumbbell Preacher Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Hanging Crunch"],
//                             [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, true, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["Curl Bar Multi Curl"],
//                             [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, false, true, true, true],
//                             [CellType.workout]]
//                
//                let cell10 = [["Mountain Climber"],
//                              [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, true, true, true, true, true],
//                              [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2],
//                             [cell3, cell4],
//                             [cell5, cell6],
//                             [cell7, cell8],
//                             [cell9, cell10],
//                             [completeCell]]
//                
//            case "B3: Complete Body":
//                
//                let cell1 = [["Pull-Up"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell2 = [["Push-Up"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell3 = [["Dumbbell Squat"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell4 = [["Crunch"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell5 = [["Dumbell Incline Press"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell6 = [["Dumbell Bent-Over Row"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell7 = [["Dumbell Alt Reverse Lunge"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell8 = [["Plank Crunch"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell9 = [["3-Way Military Press"],
//                             [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                             [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                             [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                             [false, false, true, true, true, true],
//                             [CellType.workout]]
//                
//                let cell10 = [["Single Arm Leaning Reverse Fly"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell11 = [["S-L Deadlift"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell12 = [["Russian Twist"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell13 = [["Curl-Up Hammer-Down"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell14 = [["Leaning Tricep Extension"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell15 = [["Calf Raise"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let cell16 = [["Side Sphinx Raise"],
//                              [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                              [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                              [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                              [false, false, true, true, true, true],
//                              [CellType.workout]]
//                
//                let completeCell = [[],
//                                    [],
//                                    [],
//                                    [],
//                                    [],
//                                    [CellType.completion]]
//                
//                cellArray = [[cell1, cell2, cell3, cell4],
//                             [cell5, cell6, cell7, cell8],
//                             [cell9, cell10, cell11, cell12],
//                             [cell13, cell14, cell15, cell16],
//                             [completeCell]]
//            default:
//                break
//            }
//          
//            // TESTING
//            
//            for sectionIndex in 0..<cellArray.count {
//                
//                for rowIndex in 0..<cellArray[sectionIndex].count {
//                    
//                    print("Section: \(sectionIndex) Row: \(rowIndex)")
//                    
//                    let currentCell = cellArray[sectionIndex][rowIndex] as! NSArray
//                    
//                    for workoutIndex in 1...bulkIndexForWorkout[workoutNameIndex] {
//                        
//                        counter += 1
//                        
//                        if let exerciseRecord = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: CDHelper.shared.context) as? Workout {
//                            
//                            // Session
//                            exerciseRecord.session = "1"
//                            
//                            // Routine
//                            exerciseRecord.routine = "Bulk"
//                            
//                            // Workout
//                            exerciseRecord.workout = workoutName
//                            
//                            // Title
//                            let titleArray = currentCell[0] as? NSArray
//                            exerciseRecord.exercise = titleArray![0] as? String
//                            
//                            // Index
//                            exerciseRecord.index = workoutIndex
//                            
//                            // Section
//                            exerciseRecord.tableViewSection = sectionIndex
//                            
//                            // Row
//                            exerciseRecord.tableViewRow = rowIndex
//                            
//                            if sectionIndex != cellArray.count - 1 {
//                                
//                                // RepsNumber
//                                let repsNumberArray = currentCell[1] as? NSArray
//                                exerciseRecord.repsNumber1 = repsNumberArray![0] as? String
//                                exerciseRecord.repsNumber2 = repsNumberArray![1] as? String
//                                exerciseRecord.repsNumber3 = repsNumberArray![2] as? String
//                                exerciseRecord.repsNumber4 = repsNumberArray![3] as? String
//                                exerciseRecord.repsNumber5 = repsNumberArray![4] as? String
//                                exerciseRecord.repsNumber6 = repsNumberArray![5] as? String
//                                
//                                // RepsTitle
//                                let repsTitleArray = currentCell[2] as? NSArray
//                                exerciseRecord.repsTitle1 = repsTitleArray![0] as? String
//                                exerciseRecord.repsTitle2 = repsTitleArray![1] as? String
//                                exerciseRecord.repsTitle3 = repsTitleArray![2] as? String
//                                exerciseRecord.repsTitle4 = repsTitleArray![3] as? String
//                                exerciseRecord.repsTitle5 = repsTitleArray![4] as? String
//                                exerciseRecord.repsTitle6 = repsTitleArray![5] as? String
//                            }
//                            
//                            // CellType
//                            let cellTypeArray = currentCell[3] as? NSArray
//                            exerciseRecord.cellType = cellTypeArray![0] as? String
//                            
//                        }
//                    }
//                }
//            }
//            
//            print("Added items:  \(counter)")
//
//        }
//        
//        CDHelper.saveSharedContext()
//    }
}
