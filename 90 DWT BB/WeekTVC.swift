//
//  WeekTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WeekTVC: UITableViewController {
    
    private var currentWeekWorkoutList = [[], []]
    private var daysOfWeekNumberList = [[], []]
    private var daysOfWeekColorList = [[], []]
    private var optionalWorkoutList = [[], []]
    var workoutRoutine = ""
    var workoutWeek = ""
    
    private struct Color {
        static let white = "White"
        static let gray = "Gray"
        static let green = "Green"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationItem.title = "Workout"
        
        loadArraysForCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if optionalWorkoutList[indexPath.section][indexPath.row] as! NSObject == 0 {
            
            // Don't show the "Select 1"
            cell.detailLabel.hidden = true
        }
        else {
            cell.detailLabel.hidden = false
        }
        
        if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "Orange_White_CheckMark")) {
            
            cell.accessoryView = tempAccessoryView
        }
        
        switch daysOfWeekColorList[indexPath.section][indexPath.row] as! String {
        case "White":
            cell.dayOfWeekTextField.backgroundColor = UIColor .whiteColor()
            cell.dayOfWeekTextField.textColor = UIColor .blackColor()
            
        case "Gray":
            cell.dayOfWeekTextField.backgroundColor = UIColor .grayColor()
            cell.dayOfWeekTextField.textColor = UIColor .whiteColor()
            
        case "Green":
            cell.dayOfWeekTextField.backgroundColor = UIColor(red: 133/255, green: 187/255, blue: 60/255, alpha: 1.0)
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
        
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toWorkout" {
            
            let destinationVC = segue.destinationViewController as? WorkoutTVC
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = trimStringForWorkoutName((currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!)
            destinationVC!.selectedWorkout = (currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
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
    
    private func loadArraysForCell() {
        
        if workoutRoutine == "Bulk" {
            
            // Bulk Routine
            switch workoutWeek {
            case "Week 1":
                currentWeekWorkoutList = [["B1: Chest+Tri", "B1: Legs", "B1: Back+Bi", "B1: Shoulders"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5A","5B"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white, Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0, 0], [1, 1, 0], [0], [1, 1]]
                
            case "Week 2":
                currentWeekWorkoutList = [["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B1: Shoulders", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"]]
                
                daysOfWeekNumberList = [["1"], ["2", "2"], ["3A", "3B"], ["4"], ["5", "5"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white],
                                       [Color.white, Color.white],
                                       [Color.white, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[0], [1, 1], [0, 0], [0], [1, 1], [0], [1, 1]]
                
            case "Week 3":
                currentWeekWorkoutList = [["B1: Shoulders", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B1: Shoulders", "B3: Ab Workout"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
                daysOfWeekNumberList = [["1A", "1B"], ["2"], ["3", "3"], ["4"], ["5", "5"], ["6A", "6B"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.white, Color.green],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[0, 0], [0], [1, 1], [0], [1, 1], [0, 0], [1, 1, 0]]
                
            case "Week 4":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray]]
                
                optionalWorkoutList = [[0, 0, 0], [0, 0], [0, 0, 0]]
                
            case "Week 5":
                currentWeekWorkoutList = [["B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs"]]
                
                daysOfWeekNumberList = [["1", "2"], ["3A", "3B"], ["4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[0, 0], [0, 0], [0, 0, 0, 0]]
                
            case "Week 6":
                currentWeekWorkoutList = [["B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"]]
                
                daysOfWeekNumberList = [["1"], ["2A", "2B"], ["3", "4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[0], [0, 0], [0, 0, 0, 0, 0]]
                
            case "Week 7":
                currentWeekWorkoutList = [["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"]]
                
                daysOfWeekNumberList = [["1A", "1B"], ["2", "3", "4", "5", "6"], ["7A", "7B"]]
                
                daysOfWeekColorList = [[Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green]]
                
                optionalWorkoutList = [[0, 0], [0, 0, 0, 0, 0], [0, 0]]
                
            case "Week 8":
                currentWeekWorkoutList = [["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray]]
                
                optionalWorkoutList = [[0, 0, 0, 0, 0], [0, 0], [0]]
                
            case "Week 9":
                currentWeekWorkoutList = [["Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5B"], ["6", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0, 0], [0, 0], [0, 0]]
                
            case "Week 10":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest", "B2: Arms", "B1: Shoulders"]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.gray, Color.white]]
                
                optionalWorkoutList = [[1, 1], [0], [1, 1], [1, 1, 0], [0, 0, 0]]
                
            case "Week 11":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B3: Cardio", "B3: Complete Body"]]
                
                daysOfWeekNumberList = [["1", "2"], ["3A", "3A", "3B"], ["4", "5"], ["6A", "6B"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.green, Color.green]]
                
                optionalWorkoutList = [[0, 0], [1, 1, 0], [0, 0], [0, 0], [1, 1]]
                
            case "Week 12":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B2: Shoulders"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3A", "3A", "3B"], ["4"], ["5", "5"], ["6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white],
                                       [Color.white, Color.white],
                                       [Color.gray],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[1, 1], [0], [1, 1, 0], [0], [1, 1], [0], [1, 1, 0]]
                
            default:
                currentWeekWorkoutList = [[],[]]
            }
        }
        else {
            
            // Tone Routine
            switch workoutWeek {
            case "Week 1":
                currentWeekWorkoutList = [["B1: Chest+Tri", "B1: Legs", "B1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0], [1, 1]]
                
            case "Week 2":
                currentWeekWorkoutList = [["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"]]
                
                daysOfWeekNumberList = [["1"], ["2", "2"], ["3A", "3A", "3B"], ["4", "5"], ["6", "6"], ["7"]]
                
                daysOfWeekColorList = [[Color.white],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white],
                                       [Color.white]]
                
                optionalWorkoutList = [[0], [1, 1], [1, 1, 0], [0, 0], [1, 1], [0]]
                
            case "Week 3":
                currentWeekWorkoutList = [["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"]]
                
                daysOfWeekNumberList = [["1", "1"], ["2A", "2A", "2B"], ["3", "4"], ["5", "5"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.white, Color.white],
                                       [Color.white],
                                       [Color.white, Color.white]]
                
                optionalWorkoutList = [[1, 1], [1, 1, 0], [0, 0], [1, 1], [0], [1, 1]]
                
            case "Week 4":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0, 0]]
                
            case "Week 5":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0, 0]]
                
            case "Week 6":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0, 0]]
                
            case "Week 7":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0, 0]]
                
            case "Week 8":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[0, 0, 0], [1, 1, 0], [0, 0, 0]]

            case "Week 9":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[1, 1], [0], [1, 1], [1, 1, 0], [0, 0], [1, 1, 0]]
                
            case "Week 10":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs", "B2: Shoulders", "B2: Back", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[0, 0, 0, 0, 0], [1, 1, 0], [0]]
                
            case "Week 11":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
                daysOfWeekNumberList = [["1", "1"], ["2"], ["3", "3"], ["4A", "4A", "4B"], ["5", "6"], ["7A", "7A", "7B"]]
                
                daysOfWeekColorList = [[Color.white, Color.white],
                                       [Color.gray],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white, Color.white],
                                       [Color.green, Color.green, Color.green]]
                
                optionalWorkoutList = [[1, 1], [0], [1, 1], [1, 1, 0], [0, 0], [1, 1, 0]]
                
            case "Week 12":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs", "B2: Shoulders", "B2: Back", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[0, 0, 0, 0, 0], [1, 1, 0], [0]]
                
            default:
                currentWeekWorkoutList = [[], []]
            }
        }
    }
}
