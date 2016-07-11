///
//  WorkoutTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
//import Foundation

class WorkoutTVC: CDTableViewController {

    var session = "1"
    var workoutRoutine = ""
    var selectedWorkout = ""
    
    var exerciseNameArray = [[], []]
    var exerciseRepsArray = [[], []]
    var cellArray = [[], []]
    
//    private struct CellType {
//        static let workout = "WorkoutCell"
//        static let completion = "CompletionCell"
//    }
    
//    private struct Reps {
//        
//        struct Number {
//            static let _5 = "5"
//            static let _8 = "8"
//            static let _10 = "10"
//            static let _12 = "12"
//            static let _15 = "15"
//            static let _30 = "30"
//            static let _50 = "50"
//            static let _60 = "60"
//            static let empty = ""
//        }
//        
//        struct Title {
//            static let reps = "Reps"
//            static let sec = "Sec"
//            static let empty = ""
//        }
//    }
    
    private struct Color {
        static let lightGreen = UIColor (red: 8/255, green: 175/255, blue: 90/255, alpha: 1)
        static let mediumGreen = UIColor (red: 4/255, green: 142/255, blue: 93/255, alpha: 1)
        static let darkGreen = UIColor (red: 0/255, green: 110/255, blue: 96/255, alpha: 1)
    }
    
    // MARK: - CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Workout"
        self.sort = [NSSortDescriptor(key: "tableViewSection", ascending: true),NSSortDescriptor(key: "tableViewRow", ascending: true)]
        self.sectionNameKeyPath = "tableViewSection"
        self.fetchBatchSize = 25
        self.filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND index == %@",
                                  session,
                                  workoutRoutine,
                                  selectedWorkout,
                                  "1")
        //self.havingPredicate = filter
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
        self.performFetch()
    }
    
    func loadExerciseNameArray(workout: String) {
        
        switch workout {
        case "B1: Chest+Tri":
            
            let cell1 = [["Dumbbell Chest Press"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true]]
            
            let cell2 = [["Incline Dumbbell Fly"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true]]
            
            let cell3 = [["Incline Dumbbell Press"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true]]
            
            let cell4 = [["Close Grip Dumbbell Press"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true]]
            
            let cell5 = [["Partial Dumbbell Fly"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true]]
            
            let cell6 = [["Decline Push-Up"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true]]
            
            let cell7 = [["Laying Tricep Extension"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true]]
            
            let cell8 = [["Single Arm Tricep Kickback"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true]]
            
            let cell9 = [["Diamond Push-Up"],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true]]
            
            let cell10 = [["Dips"],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true]]
            
            let cell11 = [["Abs"],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true]]
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7],
                         [cell8, cell9],
                         [cell10, cell11]]

//        case "B1: Legs":
//            
//            let cell1 = [["Wide Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Alt Lunge"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["S-U to Reverse Lunge"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["P Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["B Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["S-L Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["S-L Calf Raise"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["S Calf Raise"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Abs"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7, cell8, cell9],
//                         [completeCell]]
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
//        case "B1: Shoulders":
//            
//            let cell1 = [["Dumbbell Shoulder Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Lateral Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Upright Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Curl Bar Underhand Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Front Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Rear Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbbell Shrug"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Leaning Dumbbell Shrug"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["6-Way Shoulder"],
//                         [Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Abs"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10],
//                         [completeCell]]
//            
//        case "B2: Arms":
//            
//            let cell1 = [["Dumbbell Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell2 = [["Seated Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Curl"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Laying Curl Bar Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Dumbbell Hammer Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell6 = [["Leaning Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell7 = [["Abs"],
//                         [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1],
//                         [cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6],
//                         [cell7],
//                         [completeCell]]
//            
//        case "B2: Legs":
//            
//            let cell1 = [["2-Way Lunge"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell3 = [["2-Way Sumo Squat"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Curl Bar Split Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell5 = [["S-L Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Side to Side Squat"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["S-L Calf Raise"],
//                         [Reps.Number._50, Reps.Number._50, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Abs"],
//                          [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1],
//                         [cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Shoulders":
//            
//            let cell1 = [["Dumbbell Lateral Raise"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Arnold Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Upright Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell4 = [["One Arm Dumbbell Front Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Two Arm Front Raise Rotate"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Reverse Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell7 = [["Plank Opposite Arm Leg Raise"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Plank Crunch"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4, cell5],
//                         [cell6],
//                         [cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Chest":
//            
//            let cell1 = [["Incline Dumbbell Fly"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Incline Dumbbell Press 1"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Rotating Dumbbell Chest Press"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Incline Dumbbell Press 2"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell5 = [["Center Dumbbell Chest Press Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Decline Push-Up"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Superman Airplane"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Russian Twist"],
//                         [Reps.Number.empty, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.empty, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [UIColor.whiteColor(), Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [true, false, true, true, true, true],
//                         [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6, cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Back":
//            
//            let cell1 = [["Dumbbell Pull-Over"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Pull-Up"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Underhand Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell4 = [["One Arm Dumbbell Row"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Reverse Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Plank Row Arm Balance"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6, cell7],
//                         [completeCell]]
//            
//        case "T1: Chest+Tri":
//            
//            let cell1 = [["Dumbbell Chest Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Crunch 1"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Incline Dumbbell Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Crunch 2"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Incline Dumbbell Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Plank To Sphinx"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Curl Bar Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Curl Bar Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Dips"],
//                          [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, false, true, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["Plank Crunch"],
//                          [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2],
//                         [cell3, cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10, cell11],
//                         [completeCell]]
//            
//        case "T1: Back+Bi":
//            
//            let cell1 = [["Dumbbell Pull-Over"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Plank Hop"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Pull-Up"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Hanging Side-To-Side Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Curl Bar Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Curl Bar Twist"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbbell Preacher Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Hanging Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Curl Bar Multi Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Mountain Climber"],
//                          [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2],
//                         [cell3, cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10],
//                         [completeCell]]
//            
//        case "B3: Complete Body":
//            
//            let cell1 = [["Pull-Up"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Push-Up"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Dumbbell Squat"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Crunch"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Dumbell Incline Press"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Dumbell Bent-Over Row"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbell Alt Reverse Lunge"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Plank Crunch"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["3-Way Military Press"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Single Arm Leaning Reverse Fly"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["S-L Deadlift"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell12 = [["Russian Twist"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell13 = [["Curl-Up Hammer-Down"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell14 = [["Leaning Tricep Extension"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell15 = [["Calf Raise"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell16 = [["Side Sphinx Raise"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//
//            cellArray = [[cell1, cell2, cell3, cell4],
//                         [cell5, cell6, cell7, cell8],
//                         [cell9, cell10, cell11, cell12],
//                         [cell13, cell14, cell15, cell16],
//                         [completeCell]]
            
        default:
            break
        }
        
        // Need to create a segue for the Notes View Controller for Cardio, Ab Workout, and Rest
    }
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        
//        return cellArray.count
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        
//        return cellArray[section].count
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let workoutObject = frc.objectAtIndexPath(indexPath) as? Workout {
            
            let cellIdentifier = workoutObject.cellType
            
            if cellIdentifier == "WorkoutCell" {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! WorkoutTVC_WorkoutTableViewCell
                
                cell.title.text = workoutObject.exercise?.uppercaseString
                cell.nonUpperCaseExerciseName = workoutObject.exercise!
                cell.workoutRoutine = workoutRoutine // Bulk or Tone
                cell.selectedWorkout = selectedWorkout // B1: Chest+Tri etc...
                
                cell.repNumberLabel1.text = workoutObject.repsNumber1
                cell.repNumberLabel2.text = workoutObject.repsNumber2
                cell.repNumberLabel3.text = workoutObject.repsNumber3
                cell.repNumberLabel4.text = workoutObject.repsNumber4
                cell.repNumberLabel5.text = workoutObject.repsNumber5
                cell.repNumberLabel6.text = workoutObject.repsNumber6
                
                cell.repTitleLabel1.text = workoutObject.repsTitle1
                cell.repTitleLabel2.text = workoutObject.repsTitle2
                cell.repTitleLabel3.text = workoutObject.repsTitle3
                cell.repTitleLabel4.text = workoutObject.repsTitle4
                cell.repTitleLabel5.text = workoutObject.repsTitle5
                cell.repTitleLabel6.text = workoutObject.repsTitle6
                
                let currentCell = cellArray[indexPath.section][indexPath.row] as! NSArray
                
                let cellColor = currentCell[1] as? [UIColor]
                cell.currentWeight1.backgroundColor = cellColor![0]
                cell.currentWeight2.backgroundColor = cellColor![1]
                cell.currentWeight3.backgroundColor = cellColor![2]
                cell.currentWeight4.backgroundColor = cellColor![3]
                cell.currentWeight5.backgroundColor = cellColor![4]
                cell.currentWeight6.backgroundColor = cellColor![5]
                
                let weightFields = currentCell[2] as? [Bool]
                cell.previousWeight1.hidden = weightFields![0]
                cell.previousWeight2.hidden = weightFields![1]
                cell.previousWeight3.hidden = weightFields![2]
                cell.previousWeight4.hidden = weightFields![3]
                cell.previousWeight5.hidden = weightFields![4]
                cell.previousWeight6.hidden = weightFields![5]
                
                cell.currentWeight1.hidden = weightFields![0]
                cell.currentWeight2.hidden = weightFields![1]
                cell.currentWeight3.hidden = weightFields![2]
                cell.currentWeight4.hidden = weightFields![3]
                cell.currentWeight5.hidden = weightFields![4]
                cell.currentWeight6.hidden = weightFields![5]

                cell.currentWeight1.text = "0.0"
                cell.currentWeight2.text = "0.0"
                cell.currentWeight3.text = "0.0"
                cell.currentWeight4.text = "0.0"
                cell.currentWeight5.text = "0.0"
                cell.currentWeight6.text = "0.0"
                
                cell.originalCurrentWeight1_Text = "0.0"
                cell.originalCurrentWeight2_Text = "0.0"
                cell.originalCurrentWeight3_Text = "0.0"
                cell.originalCurrentWeight4_Text = "0.0"
                cell.originalCurrentWeight5_Text = "0.0"
                cell.originalCurrentWeight6_Text = "0.0"
                
                cell.previousWeight1.text = "0.0"
                cell.previousWeight2.text = "0.0"
                cell.previousWeight3.text = "0.0"
                cell.previousWeight4.text = "0.0"
                cell.previousWeight5.text = "0.0"
                cell.previousWeight6.text = "0.0"
                
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! WorkoutTVC_CompletionTableViewCell
                
                return cell
            }
        }
        
        //let currentCell = cellArray[indexPath.section][indexPath.row] as! NSArray
        
        //let cellIdentifier = currentCell[5] as? NSArray
        
//        if cellIdentifier![0] as? String == "WorkoutCell" {
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier((cellIdentifier![0] as? String)!, forIndexPath: indexPath) as! WorkoutTVC_WorkoutTableViewCell
        
//            let titleArray = currentCell[0] as? NSArray
//            cell.title.text = titleArray![0].uppercaseString
            
            //cell.nonUpperCaseExerciseName = titleArray![0] as! String
            //cell.workoutRoutine = workoutRoutine  // Bulk or Tone
            //cell.selectedWorkout = selectedWorkout  // B1: Chest+Tri etc...
            
//            let repNumbers = currentCell[1] as? NSArray
//            cell.repNumberLabel1.text = repNumbers![0] as? String
//            cell.repNumberLabel2.text = repNumbers![1] as? String
//            cell.repNumberLabel3.text = repNumbers![2] as? String
//            cell.repNumberLabel4.text = repNumbers![3] as? String
//            cell.repNumberLabel5.text = repNumbers![4] as? String
//            cell.repNumberLabel6.text = repNumbers![5] as? String
//            
//            let repTitles = currentCell[2] as? NSArray
//            cell.repTitleLabel1.text = repTitles![0].uppercaseString
//            cell.repTitleLabel2.text = repTitles![1].uppercaseString
//            cell.repTitleLabel3.text = repTitles![2].uppercaseString
//            cell.repTitleLabel4.text = repTitles![3].uppercaseString
//            cell.repTitleLabel5.text = repTitles![4].uppercaseString
//            cell.repTitleLabel6.text = repTitles![5].uppercaseString
            
            
            
            
//            if let workoutObjects = CDOperation.getWeightTextForExercise(session, routine: workoutRoutine, workout: selectedWorkout, exercise: titleArray![0] as! String, index: 1)  as? [Workout] {
//                
//                print("Objects in array: \(workoutObjects.count)")
//                
//                for object in workoutObjects {
//                    
//                    print("Round = \(object.round!) - Weight = \(object.weight!)")
//                }
//                
//                if workoutObjects.count != 0 {
//                    
//                    for object in workoutObjects {
//                        
//                        switch object.round as! Int {
//                        case 0:
//                            cell.currentWeight1.text = object.weight
//                            cell.originalCurrentWeight1_Text = object.weight!
//                            
//                        case 1:
//                            cell.currentWeight2.text = object.weight
//                            cell.originalCurrentWeight2_Text = object.weight!
//                            
//                        case 2:
//                            cell.currentWeight3.text = object.weight
//                            cell.originalCurrentWeight3_Text = object.weight!
//                            
//                        case 3:
//                            cell.currentWeight4.text = object.weight
//                            cell.originalCurrentWeight4_Text = object.weight!
//                            
//                        case 4:
//                            cell.currentWeight5.text = object.weight
//                            cell.originalCurrentWeight5_Text = object.weight!
//                            
//                        case 5:
//                            cell.currentWeight6.text = object.weight
//                            cell.originalCurrentWeight6_Text = object.weight!
//                            cell.currentNotes.text = object.notes?.uppercaseString
//
//                        default:
//                            break
//                        }
//                    }
//                }
//            }
            
//            return cell
//
//        }
//        else {
//            
////            let cell = tableView.dequeueReusableCellWithIdentifier((cellIdentifier![0] as? String)!, forIndexPath: indexPath) as! WorkoutTVC_CompletionTableViewCell
////            
////            return cell
//        }
        let emptyCell = UITableViewCell()
        
        return emptyCell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section != numberOfSectionsInTableView(tableView) - 1 {
            
            return "Set \(section + 1) of \(numberOfSectionsInTableView(tableView) - 1)"
        }
        else {
            
            return "Finished"
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Set the color of the header/footer text
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.whiteColor()
        
        // Set the background color of the header/footer
        header.contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        view.endEditing(true)
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
//    func loadExerciseNameArray(workout: String) {
//        
//        switch workout {
//        case "B1: Chest+Tri":
//            
//            let cell1 = [["Dumbbell Chest Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Incline Dumbbell Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Incline Dumbbell Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Close Grip Dumbbell Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Partial Dumbbell Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Decline Push-Up"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Laying Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Single Arm Tricep Kickback"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Diamond Push-Up"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Dips"],
//                          [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.empty , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["Abs"],
//                          [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7],
//                         [cell8, cell9],
//                         [cell10, cell11],
//                         [completeCell]]
//            
//        case "B1: Legs":
//            
//            let cell1 = [["Wide Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Alt Lunge"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["S-U to Reverse Lunge"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["P Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["B Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["S-L Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["S-L Calf Raise"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["S Calf Raise"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Abs"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7, cell8, cell9],
//                         [completeCell]]
//            
//        case "B1: Back+Bi":
//            
//            let cell1 = [["Dumbbell Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Pull-Over"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Pull-Up"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Curl Bar Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["One-Arm Dumbbell Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Reverse Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Close-Grip Chin-Up"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Seated Bicep Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Hammer Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Curl Bar Bicep Curl"],
//                          [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, false, false, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["Superman to Airplane"],
//                          [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7],
//                         [cell8],
//                         [cell9],
//                         [cell10],
//                         [cell11],
//                         [completeCell]]
//            
//        case "B1: Shoulders":
//            
//            let cell1 = [["Dumbbell Shoulder Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Lateral Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Upright Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Curl Bar Underhand Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Front Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Rear Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbbell Shrug"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Leaning Dumbbell Shrug"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["6-Way Shoulder"],
//                         [Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Abs"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2, cell3],
//                         [cell4, cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10],
//                         [completeCell]]
//            
//        case "B2: Arms":
//            
//            let cell1 = [["Dumbbell Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell2 = [["Seated Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Curl"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Laying Curl Bar Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Dumbbell Hammer Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell6 = [["Leaning Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell7 = [["Abs"],
//                         [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6],
//                         [cell7],
//                         [completeCell]]
//            
//        case "B2: Legs":
//            
//            let cell1 = [["2-Way Lunge"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell3 = [["2-Way Sumo Squat"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Curl Bar Split Squat"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell5 = [["S-L Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Side to Side Squat"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["S-L Calf Raise"],
//                         [Reps.Number._50, Reps.Number._50, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Abs"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1],
//                         [cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Shoulders":
//            
//            let cell1 = [["Dumbbell Lateral Raise"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Dumbbell Arnold Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Upright Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell4 = [["One Arm Dumbbell Front Raise"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Two Arm Front Raise Rotate"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Reverse Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell7 = [["Plank Opposite Arm Leg Raise"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Plank Crunch"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4, cell5],
//                         [cell6],
//                         [cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Chest":
//            
//            let cell1 = [["Incline Dumbbell Fly"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Incline Dumbbell Press 1"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Rotating Dumbbell Chest Press"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Incline Dumbbell Press 2"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell5 = [["Center Dumbbell Chest Press Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Decline Push-Up"],
//                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Superman Airplane"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Russian Twist"],
//                         [Reps.Number.empty, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.empty, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [UIColor.whiteColor(), Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [true, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6, cell7, cell8],
//                         [completeCell]]
//            
//        case "B2: Back":
//            
//            let cell1 = [["Dumbbell Pull-Over"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Pull-Up"],
//                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Curl Bar Underhand Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
//                         [false, false, false, false, false, false],
//                         [CellType.workout]]
//            
//            let cell4 = [["One Arm Dumbbell Row"],
//                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
//                         [false, false, false, false, false, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Deadlift"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, false, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Reverse Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Plank Row Arm Balance"],
//                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2],
//                         [cell3],
//                         [cell4],
//                         [cell5],
//                         [cell6, cell7],
//                         [completeCell]]
//            
//        case "T1: Chest+Tri":
//            
//            let cell1 = [["Dumbbell Chest Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Crunch 1"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Incline Dumbbell Press"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Crunch 2"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Incline Dumbbell Fly"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Plank To Sphinx"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Curl Bar Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Curl Bar Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Dumbbell Tricep Extension"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Dips"],
//                          [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, false, true, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["Plank Crunch"],
//                          [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2],
//                         [cell3, cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10, cell11],
//                         [completeCell]]
//            
//        case "T1: Back+Bi":
//            
//            let cell1 = [["Dumbbell Pull-Over"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Plank Hop"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Pull-Up"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Hanging Side-To-Side Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Curl Bar Row"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Curl Bar Twist"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbbell Preacher Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Hanging Crunch"],
//                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, true, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["Curl Bar Multi Curl"],
//                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, false, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Mountain Climber"],
//                          [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, true, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2],
//                         [cell3, cell4],
//                         [cell5, cell6],
//                         [cell7, cell8],
//                         [cell9, cell10],
//                         [completeCell]]
//            
//        case "B3: Complete Body":
//            
//            let cell1 = [["Pull-Up"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell2 = [["Push-Up"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell3 = [["Dumbbell Squat"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell4 = [["Crunch"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell5 = [["Dumbell Incline Press"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell6 = [["Dumbell Bent-Over Row"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell7 = [["Dumbell Alt Reverse Lunge"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell8 = [["Plank Crunch"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell9 = [["3-Way Military Press"],
//                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                         [false, false, true, true, true, true],
//                         [CellType.workout]]
//            
//            let cell10 = [["Single Arm Leaning Reverse Fly"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell11 = [["S-L Deadlift"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell12 = [["Russian Twist"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell13 = [["Curl-Up Hammer-Down"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell14 = [["Leaning Tricep Extension"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell15 = [["Calf Raise"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let cell16 = [["Side Sphinx Raise"],
//                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
//                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
//                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
//                          [false, false, true, true, true, true],
//                          [CellType.workout]]
//            
//            let completeCell = [[],
//                                [],
//                                [],
//                                [],
//                                [],
//                                [CellType.completion]]
//            
//            cellArray = [[cell1, cell2, cell3, cell4],
//                         [cell5, cell6, cell7, cell8],
//                         [cell9, cell10, cell11, cell12],
//                         [cell13, cell14, cell15, cell16],
//                         [completeCell]]
//            
//        default:
//            break
//        }
//        
//        // Need to create a segue for the Notes View Controller for Cardio, Ab Workout, and Rest
//    }

}
