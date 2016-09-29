//
//  MonthTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class MonthTVC: UITableViewController, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate {
    
    var sectionsArray = [[], []]
    var session = ""
    var longPGR = UILongPressGestureRecognizer()
    var indexPath = NSIndexPath()
    var request = ""
    var position = NSInteger()
    
    private struct Week {
        static let week1 = "Week 1"
        static let week2 = "Week 2"
        static let week3 = "Week 3"
        static let week4 = "Week 4"
        static let week5 = "Week 5"
        static let week6 = "Week 6"
        static let week7 = "Week 7"
        static let week8 = "Week 8"
        static let week9 = "Week 9"
        static let week10 = "Week 10"
        static let week11 = "Week 11"
        static let week12 = "Week 12"
    }
    
//    // MARK: - INITIALIZATION
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        // CDTableViewController subclass customization
//        self.entity = "Workout"
//        self.sort = [NSSortDescriptor(key: "date", ascending: true)]
//        //self.sectionNameKeyPath = "locationAtHome.storedIn"
//        self.fetchBatchSize = 25
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add a long press gesture recognizer
        self.longPGR = UILongPressGestureRecognizer(target: self, action: #selector(MonthTVC.longPressGRAction(_:)))
        self.longPGR.minimumPressDuration = 1.0
        self.longPGR.allowableMovement = 10.0
        self.tableView.addGestureRecognizer(self.longPGR)

        print("VIEWDIDLOAD")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the current session
        session = CDOperation.getCurrentSession()
        
        // Get the current routine
        navigationItem.title = CDOperation.getCurrentRoutine()
        
        findWeekList()
        
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doNothing), name: "SomethingChanged", object: nil)
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEWDIDAPPEAR")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "doNothing", object: nil)
    }
    
    func doNothing() {
        
        // Do nothing
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sectionsArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sectionsArray[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = sectionsArray[indexPath.section][indexPath.row] as? String
        
        var weekNum = NSInteger()
        
        switch indexPath.section {
        case 0:
            // 1-3
            weekNum = indexPath.row + 1
            
        case 1:
            // 4-8 or 4-9
            weekNum = indexPath.row + 4
            
        default:
            
            if CDOperation.getCurrentRoutine() == "Bulk" {
                
                //  Bulk 10-12
                weekNum = indexPath.row + 10
            }
            else {
                
                // Tone 9-12
                weekNum = indexPath.row + 9
            }
        }
        
        if weekCompleted(weekNum) {
            
            // Week completed so put a checkmark as the accessoryview icon
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "RED_White_CheckMark")) {
                
                cell.accessoryView = tempAccessoryView
            }
        }
        else {
            
            // Week was NOT completed so put the arrow as the accessory view icon
            if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "next_arrow")) {
                
                cell.accessoryView = tempAccessoryView
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 20
        }
        else {
            return 10
        }
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toWeekWorkoutList" {
            
            let destinationVC = segue.destinationViewController as? WeekTVC
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.session = session
            destinationVC?.workoutRoutine = navigationItem.title!
            destinationVC?.workoutWeek = (sectionsArray[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
        }
    }
    
    func findWeekList() {
        
        switch navigationItem.title! {
        case "Bulk":
            sectionsArray = [[Week.week1, Week.week2, Week.week3],
                             [Week.week4, Week.week5, Week.week6, Week.week7, Week.week8, Week.week9],
                             [Week.week10, Week.week11, Week.week12]]
            
        case "Tone":
            sectionsArray = [[Week.week1, Week.week2, Week.week3],
                             [Week.week4, Week.week5, Week.week6, Week.week7, Week.week8],
                             [Week.week9, Week.week10, Week.week11, Week.week12]]
            
        default:
            sectionsArray = [[], []]
        }
    }
    
    func longPressGRAction(sender: UILongPressGestureRecognizer) {
        
        if (sender.isEqual(self.longPGR)) {
            
            if (sender.state == UIGestureRecognizerState.Began) {
                
                let p = sender.locationInView(self.tableView)
                
                if let tempIndexPath = self.tableView.indexPathForRowAtPoint(p) {
                    
                    // Only show the alertview if longpressed on a cell, not a section header.
                    self.indexPath = tempIndexPath
                    
                    // get affected cell
                    let cell = self.tableView.cellForRowAtIndexPath(self.indexPath)
                    
                    let tempMessage = ("Set the status for all \(CDOperation.getCurrentRoutine())-\(cell!.textLabel!.text!) workouts.")
                    
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
                        popover.sourceRect = (cell?.bounds)!
                        popover.permittedArrowDirections = .Any
                    }
                    
                    presentViewController(alertController, animated: true, completion: nil)

                }
            }
        }
    }
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        
        let tempMessage = "Set the status for every week of \(CDOperation.getCurrentRoutine()) workouts."
        
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
    
    func AddDeleteDatesFromOneWeek() {
        
        switch self.request {
        case "Not Completed":
            
            // ***DELETE***
            
            switch CDOperation.getCurrentRoutine() {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[self.position]
                let indexArray = CDOperation.loadWorkoutIndexArray()[self.position]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[i], index: indexArray[1])
                }

            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[self.position]
                let indexArray = CDOperation.loadWorkoutIndexArray()[self.position]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.deleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[i], index: indexArray[1])
                }
            }
            
        default:
            
            // "Completed"
            // ***ADD***
            
            switch CDOperation.getCurrentRoutine() {
            case "Bulk":
                
                // Bulk
                let nameArray = CDOperation.loadWorkoutNameArray()[self.position]
                let indexArray = CDOperation.loadWorkoutIndexArray()[self.position]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[i], index: indexArray[i], useDate: NSDate())
                }
                
            default:
                
                // Tone
                let nameArray = CDOperation.loadWorkoutNameArray()[self.position]
                let indexArray = CDOperation.loadWorkoutIndexArray()[self.position]
                
                for i in 0..<nameArray.count {
                    
                    CDOperation.saveWorkoutCompleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[i], index: indexArray[i], useDate: NSDate())
                }
            }
        }
    }
    
    func AddDeleteDatesFromAllWeeks() {
        
        switch self.request {
        case "Not Completed":
            
            // ***DELETE***
            
            switch CDOperation.getCurrentRoutine() {
            case "Bulk":
                
                // Bulk
                for i in 0..<CDOperation.loadWorkoutNameArray().count {
                    
                    let nameArray = CDOperation.loadWorkoutNameArray()[i]
                    let indexArray = CDOperation.loadWorkoutIndexArray()[i]
                    
                    for j in 0..<nameArray.count {
                        
                        CDOperation.deleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[j], index: indexArray[j])
                    }
                }
                
            default:
                
                // Tone
                for i in 0..<CDOperation.loadWorkoutNameArray().count {
                    
                    let nameArray = CDOperation.loadWorkoutNameArray()[i]
                    let indexArray = CDOperation.loadWorkoutIndexArray()[i]
                    
                    for j in 0..<nameArray.count {
                        
                        CDOperation.deleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[j], index: indexArray[j])
                    }
                }
            }
            
        default:
            
            // "Completed"
            // ***ADD***
            
            switch CDOperation.getCurrentRoutine() {
            case "Bulk":
                
                // Bulk
                for i in 0..<CDOperation.loadWorkoutNameArray().count {
                    
                    let nameArray = CDOperation.loadWorkoutNameArray()[i]
                    let indexArray = CDOperation.loadWorkoutIndexArray()[i]
                    
                    for j in 0..<nameArray.count {
                        
                        CDOperation.saveWorkoutCompleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[j], index: indexArray[j], useDate: NSDate())
                    }
                }

            default:
                
                // Tone
                for i in 0..<CDOperation.loadWorkoutNameArray().count {
                    
                    let nameArray = CDOperation.loadWorkoutNameArray()[i]
                    let indexArray = CDOperation.loadWorkoutIndexArray()[i]
                    
                    for j in 0..<nameArray.count {
                        
                        CDOperation.saveWorkoutCompleteDate(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: nameArray[j], index: indexArray[j], useDate: NSDate())
                    }
                }
            }
        }
    }
    
    func verifyAddDeleteRequestFromTableViewCell() {
        
        // get affected cell
        let cell = self.tableView.cellForRowAtIndexPath(self.indexPath)
        
        self.position = self.findArrayPosition(self.indexPath)
        
        let tempMessage = ("You are about to set the status for all \(CDOperation.getCurrentRoutine())-\(cell!.textLabel!.text!) workouts to:\n\n\(self.request)\n\nDo you want to proceed?")
        
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
    
    func verifyAddDeleteRequestFromBarButtonItem() {
        
        let tempMessage = ("You are about to set the status for every week of the \(CDOperation.getCurrentRoutine()) workout to:\n\n\(self.request)\n\nDo you want to proceed?")
        
        let alertController = UIAlertController(title: "Warning", message: tempMessage, preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {
            action in
            
            self.AddDeleteDatesFromAllWeeks()
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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
    
    func weekCompleted(week: NSInteger) -> Bool {
        
        var tempWorkoutNameArray = [String]()
        var tempWorkoutIndexArray = [Int]()
        var resultsArray = [String]()
        
        switch CDOperation.getCurrentRoutine() {
        case "Bulk":
            
            // Get Build Workout Arrays
            tempWorkoutNameArray = CDOperation.loadWorkoutNameArray()[week - 1]
            tempWorkoutIndexArray = CDOperation.loadWorkoutIndexArray()[week - 1]
            
        default:
            
            // Get Tone Workout Arrays
            tempWorkoutNameArray = CDOperation.loadWorkoutNameArray()[week - 1]
            tempWorkoutIndexArray = CDOperation.loadWorkoutIndexArray()[week - 1]
        }
        
        for i in 0..<tempWorkoutIndexArray.count {
            
            let workoutCompletedObjects = CDOperation.getWorkoutCompletedObjects(CDOperation.getCurrentSession(), routine: CDOperation.getCurrentRoutine(), workout: tempWorkoutNameArray[i], index: tempWorkoutIndexArray[i])
            
            if workoutCompletedObjects.count != 0 {
                
                // Workout Completed
                resultsArray.insert("YES", atIndex: i)
            }
            else {
                
                // Workout NOT Completed
                resultsArray.insert("NO", atIndex: i)
            }
        }
        
        var workoutsCompleted = 0
        var completed = false
        
        // Complete when the week ones are finished
        switch CDOperation.getCurrentRoutine() {
        case "Bulk":
            
            // ***BULK***
            switch week {
            case 1:
                
                var group1 = "NO"
                var group2 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 4 || i == 5 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 8 || i == 9 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 6 && group1 == "YES" && group2 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 2:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 1 || i == 2 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 6 || i == 7 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 9 || i == 10 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }

                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 3:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 6 || i == 7 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 10 || i == 11 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" && group2 == "YES" && group3 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 4:
                
                for i in 0..<resultsArray.count {
                 
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 8 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 5:
                
                for i in 0..<resultsArray.count {
                    
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 8 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 6:
                
                for i in 0..<resultsArray.count {
                    
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 8 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 7:
                
                for i in 0..<resultsArray.count {
                    
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 9 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 8:
                
                for i in 0..<resultsArray.count {
                    
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 8 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 9:
                
                for i in 0..<resultsArray.count {
                    
                    // User needs to do all these workouts
                    if resultsArray[i] == "YES" {
                        
                        workoutsCompleted += 1
                    }
                }
                
                if workoutsCompleted == 8 {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 10:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 0 || i == 1 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 5 || i == 6 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }

            case 11:
                
                var group1 = "NO"
                var group2 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 2 || i == 3 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 9 || i == 10 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" && group2 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            default:
                
                // Case 12
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                var group4 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 0 || i == 1 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 7 || i == 8 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else if i == 10 || i == 11 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group4 = "YES"
                        }
                    }

                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" && group4 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
            }
            
        default:
            
            // ***TONE***
            switch week {
            case 1:
                
                var group1 = "NO"
                var group2 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 8 || i == 9 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 6 && group1 == "YES" && group2 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 2:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 1 || i == 2 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 8 || i == 9 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 3:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                var group4 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 0 || i == 1 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 2 || i == 3 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 7 || i == 8 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else if i == 10 || i == 11 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group4 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 4 && group1 == "YES" && group2 == "YES" && group3 == "YES" && group4 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 4:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }

            case 5:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 6:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 7:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 8:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 9:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                var group4 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 0 || i == 1 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 5 || i == 6 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else if i == 10 || i == 11 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group4 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" && group4 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 10:
                
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 5 || i == 6 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            case 11:
                
                var group1 = "NO"
                var group2 = "NO"
                var group3 = "NO"
                var group4 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 0 || i == 1 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else if i == 3 || i == 4 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group2 = "YES"
                        }
                    }
                        
                    else if i == 5 || i == 6 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group3 = "YES"
                        }
                    }
                        
                    else if i == 10 || i == 11 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group4 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 5 && group1 == "YES" && group2 == "YES" && group3 == "YES" && group4 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
                
            default:
                
                // Case 12
                var group1 = "NO"
                
                for i in 0..<resultsArray.count {
                    
                    if i == 5 || i == 6 {
                        
                        // User has a choice to do 1 of 2 workouts.  Only needs to do 1.
                        if resultsArray[i] == "YES" {
                            
                            group1 = "YES"
                        }
                    }
                        
                    else {
                        
                        // User needs to do all these workouts
                        if resultsArray[i] == "YES" {
                            
                            workoutsCompleted += 1
                        }
                    }
                }
                
                if workoutsCompleted == 7 && group1 == "YES" {
                    
                    completed = true
                }
                else {
                    
                    completed = false
                }
            }
        }
        
        return completed
    }
}
