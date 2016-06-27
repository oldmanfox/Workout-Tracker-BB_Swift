//
//  WeekTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WeekTVC: UITableViewController {
    
    var currentWeekWorkoutList = [[], []]
    var daysOfWeekNumberList = [[], []]
    var daysOfWeekColorList = [[], []]
    var optionalWorkoutList = [[], []]
    var workoutRoutine:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        findWeekWorkoutList()
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
        
        cell.titleLabel.text = currentWeekWorkoutList[indexPath.section][indexPath.row] as? String
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
            
        case "Green":
            cell.dayOfWeekTextField.backgroundColor = UIColor(red: 133/255, green: 187/255, blue: 60/255, alpha: 1.0)
            cell.dayOfWeekTextField.textColor = UIColor .whiteColor()
            
        default: break

        }
        
        cell.dayOfWeekTextField.layer.borderColor = UIColor .blackColor().CGColor
        cell.dayOfWeekTextField.layer.borderWidth = 1.5
        cell.dayOfWeekTextField.layer.cornerRadius = 15

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10.0
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func findWeekWorkoutList() {
        
        if workoutRoutine == "Bulk" {
            
            // Bulk Routine
            switch navigationItem.title! {
            case "Week 1":
                currentWeekWorkoutList = [["B1: Chest+Tri", "B1: Legs", "B1: Back+Bi", "B1: Shoulders"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"]]
                
                daysOfWeekNumberList = [["1", "2", "3", "4"], ["5A", "5A","5B"], ["6"], ["7", "7"]]
                
                daysOfWeekColorList = [["White", "White", "White", "White"], ["Green", "Green","Green"], ["White"], ["White", "White"]]
                
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
                
                daysOfWeekColorList = [["White"], ["White", "White"], ["White", "Green"], ["White"], ["White", "White"], ["White"], ["White", "White"]]
                
                optionalWorkoutList = [[0], [1, 1], [0, 0], [0], [1, 1], [0], [1, 1]]
                
            case "Week 3":
                currentWeekWorkoutList = [["B1: Shoulders", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B1: Shoulders", "B3: Ab Workout"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
            case "Week 4":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest"]]
                
            case "Week 5":
                currentWeekWorkoutList = [["B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs"]]
                
            case "Week 6":
                currentWeekWorkoutList = [["B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"]]
                
            case "Week 7":
                currentWeekWorkoutList = [["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"]]
                
            case "Week 8":
                currentWeekWorkoutList = [["B2: Shoulders", "Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders"]]
                
            case "Week 9":
                currentWeekWorkoutList = [["Rest", "B2: Chest", "B2: Legs", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B2: Shoulders", "Rest"]]
                
            case "Week 10":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest", "B2: Arms", "B1: Shoulders"]]
                
            case "Week 11":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest", "B2: Back"],
                                          ["B2: Arms", "B3: Ab Workout"],
                                          ["B3: Cardio", "B3: Complete Body"]]
                
            case "Week 12":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B2: Shoulders"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
            default:
                currentWeekWorkoutList = [[],[]]
            }
        }
        else {
            
            // Tone Routine
            switch navigationItem.title! {
            case "Week 1":
                currentWeekWorkoutList = [["B1: Chest+Tri", "B1: Legs", "B1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"]]
                
            case "Week 2":
                currentWeekWorkoutList = [["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"]]
                
            case "Week 3":
                currentWeekWorkoutList = [["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B1: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"]]
                
            case "Week 4":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
            case "Week 5":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
            case "Week 6":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
            case "Week 7":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]
                
            case "Week 8":
                currentWeekWorkoutList = [["B2: Chest", "B2: Legs", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B2: Back", "B2: Shoulders", "Rest"]]

            case "Week 9":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
            case "Week 10":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs", "B2: Shoulders", "B2: Back", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"]]
                
            case "Week 11":
                currentWeekWorkoutList = [["B1: Chest+Tri", "T1: Chest+Tri"],
                                          ["B2: Legs"],
                                          ["B1: Back+Bi", "T1: Back+Bi"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["B1: Shoulders", "Rest"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"]]
                
            case "Week 12":
                currentWeekWorkoutList = [["B2: Chest", "B1: Legs", "B2: Shoulders", "B2: Back", "B2: Arms"],
                                          ["B3: Cardio", "B3: Complete Body", "B3: Ab Workout"],
                                          ["Rest"]]
                
            default:
                currentWeekWorkoutList = [[], []]
            }
        }
    }
}
