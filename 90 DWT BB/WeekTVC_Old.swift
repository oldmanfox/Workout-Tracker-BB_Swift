//
//  WeekTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WeekTVC_Old: UITableViewController {
    
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
        
        if optionalWorkoutList[indexPath.section][indexPath.row] as! NSObject == false {
            
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
        
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toWorkout" {
            
            let destinationVC = segue.destinationViewController as? WorkoutTVC_Old
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = (currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC!.selectedWorkout = (currentWeekWorkoutList[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
            destinationVC!.workoutRoutine = workoutRoutine
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
                
            case "Week 4":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray]]
                
                optionalWorkoutList = [[false, false, false], [false, false], [false, false, false]]
                
            case "Week 5":
                currentWeekWorkoutList = [[WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs]]
                
                daysOfWeekNumberList = [["1", "2"], ["3A", "3B"], ["4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[false, false], [false, false], [false, false, false, false]]
                
            case "Week 6":
                currentWeekWorkoutList = [[WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back]]
                
                daysOfWeekNumberList = [["1"], ["2A", "2B"], ["3", "4", "5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray]]
                
                optionalWorkoutList = [[false], [false, false], [false, false, false, false, false]]
                
            case "Week 7":
                currentWeekWorkoutList = [[WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout]]
                
                daysOfWeekNumberList = [["1A", "1B"], ["2", "3", "4", "5", "6"], ["7A", "7B"]]
                
                daysOfWeekColorList = [[Color.gray, Color.green],
                                       [Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green]]
                
                optionalWorkoutList = [[false, false], [false, false, false, false, false], [false, false]]
                
            case "Week 8":
                currentWeekWorkoutList = [[WorkoutName.B2_Shoulders, WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray]]
                
                optionalWorkoutList = [[false, false, false, false, false], [false, false], [false]]
                
            case "Week 9":
                currentWeekWorkoutList = [[WorkoutName.Rest, WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Back],
                                          [WorkoutName.B2_Arms, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5B"], ["6", "7"]]
                
                daysOfWeekColorList = [[Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.gray, Color.green],
                                       [Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false, false], [false, false], [false, false]]
                
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
                
            case "Week 4":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
            case "Week 5":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
            case "Week 6":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
            case "Week 7":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]
                
            case "Week 8":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B2_Legs, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.B2_Back, WorkoutName.B2_Shoulders, WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3"], ["4A", "4A", "4B"], ["5", "6", "7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.gray, Color.gray, Color.white]]
                
                optionalWorkoutList = [[false, false, false], [true, true, false], [false, false, false]]

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
                
            case "Week 10":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B1_Legs, WorkoutName.B2_Shoulders, WorkoutName.B2_Back, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[false, false, false, false, false], [true, true, false], [false]]
                
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
                
            case "Week 12":
                currentWeekWorkoutList = [[WorkoutName.B2_Chest, WorkoutName.B1_Legs, WorkoutName.B2_Shoulders, WorkoutName.B2_Back, WorkoutName.B2_Arms],
                                          [WorkoutName.B3_Cardio, WorkoutName.B3_Complete_Body, WorkoutName.B3_Ab_Workout],
                                          [WorkoutName.Rest]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4", "5"], ["6A", "6A", "6B"], ["7"]]
                
                daysOfWeekColorList = [[Color.gray, Color.white, Color.gray, Color.gray, Color.gray],
                                       [Color.green, Color.green, Color.green],
                                       [Color.white]]
                
                optionalWorkoutList = [[false, false, false, false, false], [true, true, false], [false]]
                
            default:
                currentWeekWorkoutList = [[], []]
            }
        }
    }
}
