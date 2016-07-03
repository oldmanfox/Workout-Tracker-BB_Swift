//
//  WorkoutTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
//import Foundation

class WorkoutTVC: UITableViewController {

    var selectedWorkout = ""
    var exerciseNameArray = [[], []]
    var exerciseRepsArray = [[], []]
    var cellArray = [[], []]
    
    private struct CellType {
        
        static let title = "WorkoutCell"
        static let small = "WorkoutCell"
    }
    
    private struct Reps {
        
        struct Number {
            static let _5 = "5"
            static let _8 = "8"
            static let _10 = "10"
            static let _12 = "12"
            static let _15 = "15"
            static let _30 = "30"
            static let _50 = "50"
            static let _60 = "60"
            static let empty = ""
        }
        
        struct Title {
            static let reps = "Reps"
            static let sec = "Sec"
            static let empty = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadExerciseNameArray(selectedWorkout)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    func loadExerciseNameArray(workout: String) {
        
        switch workout {
        case "B1: Chest+Tri":
//            exerciseNameArray = [["Dumbbell Chest Press"],
//                                 ["Incline Dumbbell Fly", "Incline Dumbbell Press"],
//                                 ["Close Grip Dumbbell Press", "Partial Dumbbell Fly", "Decline Push-Up"],
//                                 ["Laying Tricep Extension"],
//                                 ["Single Arm Tricep Kickback", "Diamond Push-Up"],
//                                 ["Dips", "Abs"]]
//            
//            exerciseRepsArray = [[Reps._15, Reps._12, Reps._8, Reps._8, Reps.empty, Reps.empty],
//                                 [[Reps._15, Reps._12, Reps._8, Reps.empty, Reps.empty, Reps.empty], [Reps._15, Reps._12, Reps._8, Reps._8, Reps.empty, Reps.empty]],
//                                 [[Reps._15, Reps._12, Reps._8, Reps.empty, Reps.empty, Reps.empty], [Reps._15, Reps._12, Reps._8, Reps.empty, Reps.empty, Reps.empty], [Reps._15, Reps._12, Reps._8, Reps.empty, Reps.empty, Reps.empty]],
//                                 [Reps._15, Reps._12, Reps._8, Reps._8, Reps.empty, Reps.empty],
//                                 [[Reps._15, Reps._12, Reps._8, Reps._8, Reps.empty, Reps.empty], [Reps._15, Reps._12, Reps._8, Reps.empty, Reps.empty, Reps.empty]],
//                                 [[Reps._60, Reps.empty, Reps.empty, Reps.empty, Reps.empty, Reps.empty], [Reps._60, Reps.empty, Reps.empty, Reps.empty, Reps.empty, Reps.empty]]]
            
            let cell1 = [["Dumbbell Chest Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, false, true, true]]
            
            let cell2 = [["Incline Dumbbell Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, true, true, true]]
            
            let cell3 = [["Incline Dumbbell Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, false, true, true]]
            
            let cell4 = [["Close Grip Dumbbell Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, true, true, true]]
            
            let cell5 = [["Partial Dumbbell Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, true, true, true]]
            
            let cell6 = [["Decline Push-Up"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, true, true, true]]
            
            let cell7 = [["Laying Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, false, true, true]]
            
            let cell8 = [["Single Arm Tricep Kickback"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, false, true, true]]
            
            let cell9 = [["Diamond Push-Up"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, false, false, true, true, true]]
            
            let cell10 = [["Dips"],
                         [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.empty , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, true, true, true, true, true]]
            
            let cell11 = [["Abs"],
                         [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [false, true, true, true, true, true]]
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7],
                         [cell8, cell9],
                         [cell10, cell11]]

        case "B1: Legs":
            exerciseNameArray = [[CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small]]
            
            
            // Start Here Next Time
            // Add correct cell structure
        case "B1: Back+Bi":
            exerciseNameArray = [[CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small]]
            
        case "B1: Shoulders":
            exerciseNameArray = [[CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "B2: Arms":
            exerciseNameArray = [[CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small]]
            
        case "B2: Legs":
            exerciseNameArray = [[CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "B2: Shoulders":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "B2: Chest":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "B2: Back":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "T1: Chest+Tri":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "T1: Back+Bi":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small]]
            
        case "B3: Complete Body":
            exerciseNameArray = [[CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small],
                                 [CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small, CellType.title, CellType.small]]
            
        default:
            break
        }
        
        // Need to create a segue for the Notes View Controller for Cardio, Ab Workout, and Rest
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return cellArray.count
        //return exerciseNameArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return cellArray[section].count
        //return exerciseNameArray[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell", forIndexPath: indexPath) as! WorkoutTVC_WorkoutTableViewCell
        
        let currentCell = cellArray[indexPath.section][indexPath.row] as! NSArray
        
        let titleArray = currentCell[0] as? NSArray
        cell.title.text = titleArray![0].uppercaseString

        let repNumbers = currentCell[1] as? NSArray
        cell.repNumberLabel1.text = repNumbers![0] as? String
        cell.repNumberLabel2.text = repNumbers![1] as? String
        cell.repNumberLabel3.text = repNumbers![2] as? String
        cell.repNumberLabel4.text = repNumbers![3] as? String
        cell.repNumberLabel5.text = repNumbers![4] as? String
        cell.repNumberLabel6.text = repNumbers![5] as? String
        
        let repTitles = currentCell[2] as? NSArray
        cell.repTitleLabel1.text = repTitles![0] as? String
        cell.repTitleLabel2.text = repTitles![1] as? String
        cell.repTitleLabel3.text = repTitles![2] as? String
        cell.repTitleLabel4.text = repTitles![3] as? String
        cell.repTitleLabel5.text = repTitles![4] as? String
        cell.repTitleLabel6.text = repTitles![5] as? String
        
        let weightFields = currentCell[3] as? NSArray
        cell.previousWeight1.hidden = weightFields![0] as! Bool
        cell.previousWeight2.hidden = weightFields![1] as! Bool
        cell.previousWeight3.hidden = weightFields![2] as! Bool
        cell.previousWeight4.hidden = weightFields![3] as! Bool
        cell.previousWeight5.hidden = weightFields![4] as! Bool
        cell.previousWeight6.hidden = weightFields![5] as! Bool
        
        cell.currentWeight1.hidden = weightFields![0] as! Bool
        cell.currentWeight2.hidden = weightFields![1] as! Bool
        cell.currentWeight3.hidden = weightFields![2] as! Bool
        cell.currentWeight4.hidden = weightFields![3] as! Bool
        cell.currentWeight5.hidden = weightFields![4] as! Bool
        cell.currentWeight6.hidden = weightFields![5] as! Bool
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Set \(section + 1) of \(numberOfSectionsInTableView(tableView))"
    }
    
    

    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Set the color of the header/footer text
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.whiteColor()
        
        // Set the background color of the header/footer
        //header.contentView.backgroundColor = UIColor (red: 91/255, green: 91/255, blue: 91/255, alpha: 1)
        header.contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        
//        switch indexPath.row {
//        case 0:
//            return 292
//        case 1:
//            return 292
//        case 2:
//            return 292
//        case 3:
//            return 292
//        case 4:
//            return 292
//        case 5:
//            return 292
//        case 6:
//            return 292
//        case 7:
//            return 292
//        default:
//            return 0
//        }
//
//        
////        if indexPath.row == 0 {
////            
////            return 292
////        }
////        else {
////            
////            return 392
////        }
//        
////        if isLandscapeOrientation() {
////            return hasImageAtIndexPath(indexPath) ? 140.0 : 120.0
////        } else {
////            return hasImageAtIndexPath(indexPath) ? 235.0 : 155.0
////        }
//    }
    
//    func isLandscapeOrientation() -> Bool {
//        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
