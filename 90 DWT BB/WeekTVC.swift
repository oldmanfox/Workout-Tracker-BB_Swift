//
//  WeekTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WeekTVC: UITableViewController, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate {
    
    private var currentWeekWorkoutList = [[], []]
    private var daysOfWeekNumberList = [[], []]
    private var daysOfWeekColorList = [[], []]
    private var optionalWorkoutList = [[], []]
    private var workoutIndexList = [[], []]
    
    var workoutRoutine = ""
    var session = ""
    var workoutWeek = ""
    
    var longPGR = UILongPressGestureRecognizer()
    var indexPath = NSIndexPath()
    var position = NSInteger()
    var request = ""
    
    private struct Color {
        static let white = "White"
        static let gray = "Gray"
        static let green = "Green"
    }
    
    private struct WorkoutName {
        static let B1_Chest_Tri = "B1: Chest+Tri"
        static let B1_Legs = "B1: Legs"
        static let B1_Back_Bi = "B1: Back+Bi"
        static let B1_Shoulders = "B1: Shoulders"
        
        static let B2_Arms = "B2: Arms"
        static let B2_Legs = "B2: Legs"
        static let B2_Shoulders = "B2: Shoulders"
        static let B2_Chest = "B2: Chest"
        static let B2_Back = "B2: Back"
        
        static let T1_Chest_Tri = "T1: Chest+Tri"
        static let T1_Back_Bi = "T1: Back+Bi"
        
        static let B3_Complete_Body = "B3: Complete Body"
        static let B3_Cardio = "B3: Cardio"
        static let B3_Ab_Workout = "B3: Ab Workout"
        
        static let Rest = "Rest"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Workout"
        
        loadArraysForCell()
        
        // Add rightBarButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(WeekTVC.editButtonPressed(_:)))
        
        // Add a long press gesture recognizer
        self.longPGR = UILongPressGestureRecognizer(target: self, action: #selector(MonthTVC.longPressGRAction(_:)))
        self.longPGR.minimumPressDuration = 1.0
        self.longPGR.allowableMovement = 10.0
        self.tableView.addGestureRecognizer(self.longPGR)

        print("SHARED CONTEXT - \(CDOperation.objectCountForEntity("Workout", context: CDHelper.shared.context))")
        
        print("IMPORT CONTEXT - \(CDOperation.objectCountForEntity("Workout", context: CDHelper.shared.importContext))")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doNothing), name: "SomethingChanged", object: nil)

        self.tableView.reloadData()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "doNothing", object: nil)
    }
    
    func doNothing() {
        
        // Do nothing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func editButtonPressed(sender: UIBarButtonItem) {
        
        let tempMessage = "Set the status for all workouts of:\n\n\(workoutRoutine) - \(workoutWeek)"
        
        let alertController = UIAlertController(title: "Workout Status", message: tempMessage, preferredStyle: .ActionSheet)
        
        let notCompletedAction = UIAlertAction(title: "Not Completed", style: .Destructive, handler: {
            action in
            
            self.request = "Not Completed"
            self.verifyAddDeleteRequestFromBarButtonItem()
        })
        
        let completedAction = UIAlertAction(title: "Completed", style: .Default, handler: {
            action in
            
            self.request = "Completed"
            self.verifyAddDeleteRequestFromBarButtonItem()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(notCompletedAction)
        alertController.addAction(completedAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.barButtonItem = sender
            popover.sourceView = self.view
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    func longPressGRAction(sender: UILongPressGestureRecognizer) {
     
        if (sender.isEqual(self.longPGR)) {
            
            if sender.state == UIGestureRecognizerState.Began {
                
                let p = sender.locationInView(self.tableView)
                
                if let tempIndexPath = self.tableView.indexPathForRowAtPoint(p) {
                    
                    self.indexPath = tempIndexPath
                    self.position = self.findArrayPosition(self.indexPath)
                    
                    // get affected cell and label
                    let cell = self.tableView.cellForRowAtIndexPath(self.indexPath) as! WeekTVC_TableViewCell
                    
                    let tempMessage = ("Set the status for:\n\n\(workoutRoutine) - \(workoutWeek) - \(cell.titleLabel.text!)")
                    
                    let alertController = UIAlertController(title: "Workout Status", message: tempMessage, preferredStyle: .ActionSheet)
                    
                    let notCompletedAction = UIAlertAction(title: "Not Completed", style: .Destructive, handler: {
                        action in
                        
                        self.request = "Not Completed"
                        self.verifyAddDeleteRequestFromTableViewCell()
                    })
                    
                    let completedAction = UIAlertAction(title: "Completed", style: .Default, handler: {
                        action in
                        
                        self.request = "Completed"
                        self.verifyAddDeleteRequestFromTableViewCell()
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    
                    alertController.addAction(notCompletedAction)
                    alertController.addAction(completedAction)
                    alertController.addAction(cancelAction)
                    
                    if let popover = alertController.popoverPresentationController {
                        
                        popover.sourceView = cell
                        popover.delegate = self
                        popover.sourceRect = (cell.bounds)
                        popover.permittedArrowDirections = .Any
                    }
                    
                    presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func verifyAddDeleteRequestFromTableViewCell() {
        
        // get affected cell
        let cell = self.tableView.cellForRowAtIndexPath(self.indexPath) as! WeekTVC_TableViewCell
        
        self.position = self.findArrayPosition(self.indexPath)
        
        let tempMessage = ("You are about to set the status for\n\n\(CDOperation.getCurrentRoutine()) - \(workoutWeek) - \(cell.titleLabel.text!)\n\nto:\n\n\(self.request)\n\nDo you want to proceed?")
        
        let alertController = UIAlertController(title: "Warning", message: tempMessage, preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {
            action in
            
            self.addDeleteDate()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func verifyAddDeleteRequestFromBarButtonItem() {
        
        let tempMessage = "You are about to set the status for all workouts of:\n\n\(workoutRoutine) - \(workoutWeek)\n\nto:\n\n\(self.request)\n\nDo you want to proceed?"
        
        let alertController = UIAlertController(title: "Warning", message: tempMessage, preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {
            action in
            
            self.AddDeleteDatesFromOneWeek()
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addDeleteDate() {
        
        switch self.request {
        case "Not Completed":
            
            // ***DELETE***
            
            switch workoutRoutine {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for _ in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(session, routine: workoutRoutine, workout: nameArray[position], index: indexArray[position])
                }
                
            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for _ in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(session, routine: workoutRoutine, workout: nameArray[position], index: indexArray[position])
                }
            }

            // Update TableViewCell Accessory Icon - Arrow
            let cell = self.tableView.cellForRowAtIndexPath(self.indexPath) as! WeekTVC_TableViewCell
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "next_arrow")) {
                
                cell.accessoryView = tempAccessoryView
            }
            
        default:
            
            // Completed
            
            // ***ADD***
            
            switch workoutRoutine {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for _ in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: nameArray[position], index: indexArray[position], useDate: NSDate())
                }

            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for _ in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: nameArray[position], index: indexArray[position], useDate: NSDate())
                }
            }
            
            // Update TableViewCell Accessory Icon - Checkmark
            let cell = self.tableView.cellForRowAtIndexPath(self.indexPath) as! WeekTVC_TableViewCell
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "RED_White_CheckMark")) {
                
                cell.accessoryView = tempAccessoryView
            }
        }
    }

    func AddDeleteDatesFromOneWeek() {
        
        switch self.request {
        case "Not Completed":
            
            // ***DELETE***
            
            switch workoutRoutine {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(session, routine: workoutRoutine, workout: nameArray[i], index: indexArray[i])
                }
                
            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(session, routine: workoutRoutine, workout: nameArray[i], index: indexArray[i])
                }
            }
            
        default:
            
            // Completed
            
            // ***ADD***
            
            switch workoutRoutine {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: nameArray[i], index: indexArray[i], useDate: NSDate())
                }
                
            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[getIntValueforWeekString() - 1]
                let indexArray = CDOperation.loadWorkoutIndexArray()[getIntValueforWeekString() - 1]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: nameArray[i], index: indexArray[i], useDate: NSDate())
                }
            }
        }
    }
    
    func findArrayPosition(indexPath: NSIndexPath) -> NSInteger {
        
        var position = NSInteger(0)
        
        for i in 0...indexPath.section {
            
            if (i == indexPath.section) {
                
                position = position + (indexPath.row + 1)
            }
            else {
                
                let totalRowsInSection = self.tableView.numberOfRowsInSection(i)
                
                position = position + totalRowsInSection
            }
        }
        
        return position - 1
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return currentWeekWorkoutList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return currentWeekWorkoutList[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! WeekTVC_TableViewCell

        // Configure the cell...
        
        cell.titleLabel.text = trimStringForWorkoutName((currentWeekWorkoutList[indexPath.section][indexPath.row] as? String)!)
        cell.dayOfWeekTextField.text = daysOfWeekNumberList[indexPath.section][indexPath.row] as? String
        
        if optionalWorkoutList[indexPath.section][indexPath.row] as! NSObject == false {
            
            // Don't show the "Select 1"
            cell.detailLabel.hidden = true
        }
        else {
            cell.detailLabel.hidden = false
        }
        
        let workoutCompletedObjects = CDOperation.getWorkoutCompletedObjects(session, routine: workoutRoutine, workout: currentWeekWorkoutList[indexPath.section][indexPath.row] as! NSString, index: workoutIndexList[indexPath.section][indexPath.row] as! NSNumber)
        
        if workoutCompletedObjects.count != 0 {
            
            // Workout completed so put a checkmark as the accessoryview icon
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "RED_White_CheckMark")) {
                
                cell.accessoryView = tempAccessoryView
            }
        }
        else {
            
            // Workout was NOT completed so put the arrow as the accessory view icon
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "next_arrow")) {
                
                cell.accessoryView = tempAccessoryView
            }
        }

        switch daysOfWeekColorList[indexPath.section][indexPath.row] as! String {
        case "White":
            cell.dayOfWeekTextField.backgroundColor = UIColor .whiteColor()
            cell.dayOfWeekTextField.textColor = UIColor .blackColor()
            
        case "Gray":
            cell.dayOfWeekTextField.backgroundColor = UIColor .grayColor()
            cell.dayOfWeekTextField.textColor = UIColor .whiteColor()
            
        case "Green":
            cell.dayOfWeekTextField.backgroundColor = UIColor(red: 8/255, green: 175/255, blue: 90/255, alpha: 1.0)
            cell.dayOfWeekTextField.textColor = UIColor .whiteColor()
            
        default: break

        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "\(workoutRoutine) - \(workoutWeek)"
        }
        else {
            return ""
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 30
        }
        else {
            return 10
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? WeekTVC_TableViewCell {
            
            if cell.titleLabel.text == "Rest" || cell.titleLabel.text == "Cardio" || cell.titleLabel.text == "Ab Workout" {
                
                self.performSegueWithIdentifier("toNotes", sender: indexPath)
            }
            else {
                
                self.performSegueWithIdentifier("toWorkout", sender: indexPath)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toWorkout" {
            
            let destinationVC = segue.destinationViewController as? WorkoutTVC
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = (self.currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC!.selectedWorkout = (self.currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC?.workoutIndex = (self.workoutIndexList[(selectedRow?.section)!][(selectedRow?.row)!] as? Int)!
            destinationVC!.workoutRoutine = self.workoutRoutine
            destinationVC?.session = self.session
            destinationVC?.workoutWeek = self.workoutWeek
        }
        else {
            // NotesViewController
            
            let destinationVC = segue.destinationViewController as? NotesViewController
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = (self.currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC!.selectedWorkout = (self.currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC?.workoutIndex = (self.workoutIndexList[(selectedRow?.section)!][(selectedRow?.row)!] as? Int)!
            destinationVC!.workoutRoutine = self.workoutRoutine
            destinationVC?.session = self.session
            destinationVC!.workoutWeek = self.workoutWeek
        }
    }
    
    private func trimStringForWorkoutName(originalString: String) -> String {
        
        switch originalString {
            
        case originalString where originalString.hasPrefix("B"):
            
            return originalString.substringFromIndex(originalString.startIndex.advancedBy(4))
            
        case originalString where originalString.hasPrefix("T"):
            
            var tempString = originalString.substringFromIndex(originalString.startIndex.advancedBy(4))
            tempString = "T - \(tempString)"
            return tempString
            
        default:
            return originalString
            
        }
    }
    
    func getIntValueforWeekString() -> Int {
        
        switch workoutWeek {
        case "Week 1":
            
            return 1
          
        case "Week 2":
            
            return 2
            
        case "Week 3":
            
            return 3
            
        case "Week 4":
            
            return 4
            
        case "Week 5":
            
            return 5
            
        case "Week 6":
            
            return 6
            
        case "Week 7":
            
            return 7
            
        case "Week 8":
            
            return 8
            
        case "Week 9":
            
            return 9
            
        case "Week 10":
            
            return 10
            
        case "Week 11":
            
            return 11

        default:
            
            // Week 12
            return 12
        }
    }
    
    private func loadArraysForCell() {
        
        if workoutRoutine == "Bulk" {
            
            // Bulk Routine
            switch workoutWeek {
            case "Week 1":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.B1_Legs, WorkoutName.B1_Back_Bi, WorkoutName.B1_Shoulders],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5A","5B"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white, Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[false, false, false, false], [true, true, false], [false], [true, true]]
                
                workoutIndexList = [[1, 1, 1, 1], [1, 1, 1], [1], [2, 1]]
                
            case "Week 2":
                currentWeekWorkoutList = [[WorkoutName.B1_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B1_Shoulders, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B1_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi]]
                
                daysOfWeekNumberList = [["1"], ["2", "2"], ["3A", "3B"], ["4"], ["5", "5"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white],
                                       [Color.white, Color.white],
                                       [Color.white, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[false], [true, true], [false, false], [false], [true, true], [false], [true, true]]
                
                workoutIndexList = [[2], [2, 1], [2, 2], [2], [3, 2], [3], [3, 2]]
                
                case "Week 3":
                currentWeekWorkoutList = [[WorkoutName.B1_Shoulders, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B1_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B1_Shoulders, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1A", "1B"], ["2"], ["3", "3"], ["4"], ["5", "5"], ["6A", "6B"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white, Color.green],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[false, false], [false], [true, true], [false], [true, true], [false, false], [true, true, false]]
                
                workoutIndexList = [[3, 3], [3], [4, 3], [4], [4, 3], [4, 4], [2, 2, 5]]
                
            case "Week 4":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray]]
                
                optionalWorkoutList = [[false, false, false], [false, false], [false, false, false]]
                
                workoutIndexList = [[1, 1, 1], [1, 6], [1, 4, 2]]
                
            case "Week 5":
                currentWeekWorkoutList = [[WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs]]
                
                daysOfWeekNumberList = [["1", "2"], ["3A", "3B"], ["4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[false, false], [false, false], [false, false, false, false]]
                
                workoutIndexList = [[2, 2], [2, 7], [2, 5, 3, 3]]
                
            case "Week 6":
                currentWeekWorkoutList = [[WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back]]
                
                daysOfWeekNumberList = [["1"], ["2A", "2B"], ["3", "4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[false], [false, false], [false, false, false, false, false]]
                
                workoutIndexList = [[3], [3, 8], [3, 6, 4, 4, 4]]
                
                case "Week 7":
                currentWeekWorkoutList = [[WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1A", "1B"], ["2", "3", "4", "5", "6"], ["7A", "7B"]]
                
                daysOfWeekColorList = [[Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green]]
                
                optionalWorkoutList = [[false, false], [false, false, false, false, false], [false, false]]
                
                workoutIndexList = [[4, 9], [4, 7, 5, 5, 5], [5, 10]]
                
            case "Week 8":
                currentWeekWorkoutList = [[WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray]]
                
                optionalWorkoutList = [[false, false, false, false, false], [false, false], [false]]
                
                workoutIndexList = [[5, 8, 6, 6, 6], [6, 11], [6]]
                
            case "Week 9":
                currentWeekWorkoutList = [[WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5B"], ["6", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false, false], [false, false], [false, false]]
                
                workoutIndexList = [[9, 7, 7, 7], [7, 12], [7, 10]]
                
            case "Week 10":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B2_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest, WorkoutName.B2_Arms, WorkoutName.B1_Shoulders]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.gray, Color.white]]
                
                optionalWorkoutList = [[true, true], [false], [true, true], [true, true, false], [false, false, false]]
                
                workoutIndexList = [[5, 4], [8], [5, 4], [3, 3, 13], [11, 8, 5]]
                
            case "Week 11":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B1_Legs],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body]]
                
                daysOfWeekNumberList = [["1", "2"], ["3A", "3A", "3B"], ["4", "5"], ["6A", "6B"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.green, Color.green]]
                
                optionalWorkoutList = [[false, false], [true, true, false], [false, false], [false, false], [true, true]]
                
                workoutIndexList = [[8, 5], [4, 4, 14], [12, 8], [9, 15], [5, 5]]
                
            case "Week 12":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B2_Legs],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B2_Shoulders],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3A", "3A", "3B"], ["4"], ["5", "5"], ["6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.gray],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[true, true], [false], [true, true, false], [false], [true, true], [false], [true, true, false]]
                
                workoutIndexList = [[6, 5], [9], [6, 6, 16], [13], [6, 5], [8], [7, 7, 17]]
                
            default:
                currentWeekWorkoutList = [[],[]]
            }
        }
        else {
            
            // Tone Routine
            switch workoutWeek {
            case "Week 1":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.B1_Legs, WorkoutName.B1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B1_Shoulders, WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false], [true, true]]
                
                workoutIndexList = [[1, 1, 1], [1, 1, 1], [1, 1], [2, 1]]
                
            case "Week 2":
                currentWeekWorkoutList = [[WorkoutName.B1_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B1_Shoulders, WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B1_Legs]]
                
                daysOfWeekNumberList = [["1"], ["2", "2"], ["3A", "3A", "3B"], ["4", "5"], ["6", "6"], ["7"]]
                
                daysOfWeekColorList = [[Color.white],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white],
                                       [Color.white]]
                
                optionalWorkoutList = [[false], [true, true], [true, true, false], [false, false], [true, true], [false]]
                
                workoutIndexList = [[2], [2, 1], [2, 2, 2], [2, 2], [3, 2], [3]]
                
            case "Week 3":
                currentWeekWorkoutList = [[WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B1_Shoulders, WorkoutName.Rest],
                                          [WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B1_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi]]
                
                daysOfWeekNumberList = [["1", "1"], ["2A", "2A", "2B"], ["3", "4"], ["5", "5"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[true, true], [true, true, false], [false, false], [true, true], [false], [true, true]]
                
                workoutIndexList = [[3, 2], [3, 3, 3], [3, 3], [4, 3], [4], [4, 3]]
                
            case "Week 4":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
                workoutIndexList = [[1, 1, 1], [4, 4, 4], [1, 1, 4]]
                
            case "Week 5":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
                workoutIndexList = [[2, 2, 2], [5, 5, 5], [2, 2, 5]]
                
            case "Week 6":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
                workoutIndexList = [[3, 3, 3], [6, 6, 6], [3, 3, 6]]
                
            case "Week 7":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
                workoutIndexList = [[4, 4, 4], [7, 7, 7], [4, 4, 7]]
                
            case "Week 8":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]

                workoutIndexList = [[5, 5, 5], [8, 8, 8], [5, 5, 8]]
                
            case "Week 9":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B2_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B1_Shoulders, WorkoutName.Rest],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[true, true], [false], [true, true], [true, true, false], [false, false], [true, true, false]]
                
                workoutIndexList = [[5, 4], [6], [5, 4], [9, 9, 9], [4, 9], [10, 10, 10]]
                
            case "Week 10":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B1_Legs, WorkoutName.B2_Shoulders, WorkoutName.B2_Back, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[false, false, false, false, false], [true, true, false], [false]]
                
                workoutIndexList = [[6, 5, 6, 6, 6], [11, 11, 11], [10]]
                
            case "Week 11":
                currentWeekWorkoutList = [[WorkoutName.B1_Chest_Tri, WorkoutName.T1_Chest_Tri],
                                          [WorkoutName.B2_Legs],
                                          [WorkoutName.B1_Back_Bi, WorkoutName.T1_Back_Bi],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B1_Shoulders, WorkoutName.Rest],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[true, true], [false], [true, true], [true, true, false], [false, false], [true, true, false]]
                
                workoutIndexList = [[6, 5], [7], [6, 5], [12, 12, 12], [5, 11], [13, 13, 13]]
                
            case "Week 12":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B1_Legs, WorkoutName.B2_Shoulders, WorkoutName.B2_Back, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[false, false, false, false, false], [true, true, false], [false]]
                
                workoutIndexList = [[7, 6, 7, 7, 7], [14, 14, 14], [12]]
                
            default:
                currentWeekWorkoutList = [[], []]
            }
        }
    }
}
