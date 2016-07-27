//
//  ExerciseChartViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 7/20/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData

class ExerciseChartViewController: UIViewController, SChartDatasource {
    
    @IBOutlet weak var chartView: UIView!
    
    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var exerciseName = ""
    var graphDataPoints = [String?]()
    var workoutIndex = 0
    
    //var chart = ShinobiChart(frame: CGRectZero)
    
    var workoutObjects = [Workout]()
    
    @IBAction func dismissButtonPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Create the chart
        let chart = ShinobiChart(frame: CGRectInset(chartView.bounds, 0, 0))
        chart.title = exerciseName
        chart.titleLabel.textColor = UIColor (red: 175/255, green: 89/255, blue: 8/255, alpha: 1)
        chart.titleCentresOn = SChartTitleCentresOn.Chart
        
        chart.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

        // Add a pair of axes
        let xAxis = SChartCategoryAxis()
        xAxis.title = findXAxisTitle()
        xAxis.style.titleStyle.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        //xAxis.rangePaddingLow = @(0.05);
        //xAxis.rangePaddingHigh = @(0.3);
        chart.xAxis = xAxis;
        
        let yAxis = SChartNumberAxis()
        yAxis.title = findYAxisTitle()
        yAxis.style.titleStyle.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        //yAxis.rangePaddingLow = @(1.0);
        //yAxis.rangePaddingHigh = @(1.0);
        chart.yAxis = yAxis;

        // Add chart to the view
        chartView.addSubview(chart)

        // This view controller will provide data to the chart
        chart.datasource = self
        
        // Show the legend on all devices
        chart.legend.hidden = false
        chart.legend.style.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        chart.legend.placement = .OutsidePlotArea
        chart.legend.position = .BottomMiddle
        
        // Enable gestures
        yAxis.enableGesturePanning = true;
        yAxis.enableGestureZooming = true;
        xAxis.enableGesturePanning = true;
        xAxis.enableGestureZooming = true;
        
        // Show the x and y axis gridlines
        xAxis.style.majorGridLineStyle.showMajorGridLines = true;
        yAxis.style.majorGridLineStyle.showMajorGridLines = true;
    }
    
    // MARK:- SChartDatasource Functions
    
    func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
        
        let highestIndexFound = NSInteger(GetHighestDatabaseIndex())
        
        return highestIndexFound;
    }
    
    func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
        /*
         NSString *tempString = [NSString stringWithFormat:@"%@ - %@", self.appDelegate.graphWorkout, self.appDelegate.graphTitle];
         
         NSArray *columnSeriesWorkouts = @[@"B1: Chest+Tri - Dips",
         @"B1: Chest+Tri - Abs",
         @"B1: Back+Bi - Close-Grip Chin-Up",
         @"B2: Chest - Incline Dumbbell Press 2"];
         int numMatches = 0;
         for (int i = 0; i < columnSeriesWorkouts.count; i++) {
         
         if ([tempString isEqualToString:columnSeriesWorkouts[i]]) {
         
         numMatches++;
         }
         }
         
         if (numMatches == 1) {
         
         // Match - ColumnSeries
         SChartColumnSeries *columnSeries = [[SChartColumnSeries alloc] init];
         
         // Enable area fill
         //columnSeries.style.areaColorGradient = [UIColor clearColor];
         
         NSNumber *tryNumber = [NSNumber numberWithInteger:index + 1];
         
         self.matches = nil;
         self.matches = [self.objects objectAtIndex:index * 6];
         NSString *tempNote = self.matches.notes;
         
         columnSeries.title = [NSString stringWithFormat:@"Try %@ - %@", tryNumber, tempNote];
         
         return columnSeries;
         }
         else {
         
         // No Match - LineSeries
         SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
         
         // Enable area fill
         //lineSeries.style.showFill = YES;
         //lineSeries.style.fillWithGradient = YES;
         //lineSeries.style.areaColorLowGradient = [UIColor clearColor];
         
         lineSeries.style.lineWidth = @(2.0);
         lineSeries.style.pointStyle.showPoints = YES;
         NSNumber *tryNumber = [NSNumber numberWithInteger:index + 1];
         
         self.matches = nil;
         self.matches = [self.objects objectAtIndex:index * 6];
         NSString *tempNote = self.matches.notes;
         
         lineSeries.title = [NSString stringWithFormat:@"Try %@ - %@", tryNumber, tempNote];
         
         //series.style.dataPointLabelStyle.showLabels = YES;
         
         return lineSeries;
         }
         */
        
        // ColumnSeries
        let columnSeries = SChartColumnSeries()
        
        // Enable area fill
        //columnSeries.style.areaColorGradient = [UIColor clearColor];
        
        let tryNumber = NSNumber(int: index + 1)
        
        if (ColumnSeriesMatchAtIndex(index)) {
            
            let matches = self.workoutObjects.last! as Workout
            let tempNote = matches.notes
            
            if tempNote == nil {
                
                columnSeries.title = "Try \(tryNumber) - "
            }
            else {
                
                columnSeries.title = "Try \(tryNumber) - \(tempNote!)"
            }
        }
        else {
            
            columnSeries.title = "Try \(tryNumber) - "
        }
        
        return columnSeries;
    }
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
    
        // Get the number of reps labels in the cell that aren't ""
        var counter = 0
        
        for object in graphDataPoints {
            
            if object != "" {
                
                counter += 1
            }
        }
        
        return counter
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
    
        let dataPoint = SChartDataPoint()
        
        self.workoutObjects = [Workout]()
        
        matchAtIndex(dataIndex, workoutIndex: seriesIndex)
        
        var tempReps = graphDataPoints[dataIndex]
        
        var tempString1 = ""
        var tempString2 = ""
        
        var duplicate = 0;
        
        for i in 0...dataIndex {
            
            tempString1 = graphDataPoints[i]!
            
            if (tempReps == tempString1) {
                duplicate += 1
                
                if (duplicate > 1) {
                    
                    tempString2 = createXAxisString(tempReps!, spacesToAdd: duplicate - 1)
                    
                }else {
                    
                    tempString2 = tempString1;
                }
            }
        }
        
        tempReps = tempString2;
        dataPoint.xValue = tempReps;
        
        if (self.workoutObjects.count == 0) {
            
            // No Matches
            dataPoint.yValue = NSNumber(double: 0.0)
        }
        else {
            
            // Found a match
            let matches = workoutObjects.last!
            let yValue = Double(matches.weight!)
            dataPoint.yValue = NSNumber(double: yValue!)
        }
        
        return dataPoint
    }
    
    // MARK:- Utility Methods
    
    func GetHighestDatabaseIndex() -> NSInteger {
    
        // Get Data from the database
        let request = NSFetchRequest( entityName: "Workout")
        let sortDate = NSSortDescriptor( key: "index", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@",
                                 session,
                                 workoutRoutine,
                                 selectedWorkout,
                                 exerciseName)
        
        request.predicate = filter
        
        do {
            if let tempWorkoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                self.workoutObjects = tempWorkoutObjects
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                var highestDatabaseIndex = 0
                
                for object in tempWorkoutObjects {
                    
                    let objectIndex = object.index
                    
                    if objectIndex?.integerValue > highestDatabaseIndex {
                        
                        highestDatabaseIndex = (objectIndex?.integerValue)!
                    }
                }
                
                return highestDatabaseIndex
                
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return 0
    }
    
    func ColumnSeriesMatchAtIndex(workoutIndex: NSInteger) -> Bool {
    
        let tempWorkoutIndex = NSNumber(integer: workoutIndex + 1)
        
        // Get Data from the database.
        let request = NSFetchRequest( entityName: "Workout")
        let sortRound = NSSortDescriptor( key: "round", ascending: true)
        request.sortDescriptors = [sortRound]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index == %@",
                                 session,
                                 workoutRoutine,
                                 selectedWorkout,
                                 exerciseName,
                                 tempWorkoutIndex)
        
        request.predicate = filter
        
        do {
            if let tempWorkoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                self.workoutObjects = tempWorkoutObjects
                //print("workoutObjects.count = \(workoutObjects.count)")
                
                if tempWorkoutObjects.count == 0 {
                    
                    return false
                }
                else {
                    
                    return true
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return false
    }
    
    func matchAtIndex(round: NSInteger, workoutIndex: NSInteger) {
    
        var roundConverted = NSNumber(integer: round)
        
        let tempWorkoutIndex = NSNumber(integer: workoutIndex + 1)
        
        // @"B2: Chest - Russian Twist" is the only one that starts out in the second index of an array.
        let tempString = "\(selectedWorkout) - \(exerciseName)"
        
        if tempString == "B2: Chest - Russian Twist" {
            
            roundConverted = NSNumber(integer: round + 1)
        }
        
        let request = NSFetchRequest( entityName: "Workout")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        let filter = NSPredicate(format: "session == %@ AND routine == %@ AND workout == %@ AND exercise == %@ AND index == %@ AND round == %@",
                                 session,
                                 workoutRoutine,
                                 selectedWorkout,
                                 exerciseName,
                                 tempWorkoutIndex,
                                 roundConverted)
        
        request.predicate = filter

        do {
            if let tempWorkoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                
                //print("workoutObjects.count = \(workoutObjects.count)")
                self.workoutObjects = tempWorkoutObjects
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    func createXAxisString(initialString: NSString, spacesToAdd: NSNumber) -> String {
    
        var tempString = initialString
        let spacesString = " "
        
        for _ in 0..<spacesToAdd.integerValue {
            
            tempString = tempString.stringByAppendingString(spacesString)
        }
        
        return tempString as String
    }
    
    func findXAxisTitle() -> String {
        
        let xAxisSecArray = ["B1: Chest+Tri - Dips",
                             "B1: Chest+Tri - Abs",
                             "B1: Back+Bi - Close-Grip Chin-Up",
                             "B1: Back+Bi - Superman to Airplane",
                             "B1: Legs - S-L Calf Raise",
                             "B1: Legs - S Calf Raise",
                             "B1: Legs - Abs",
                             "B2: Chest - Russian Twist",
                             "B2: Back - Plank Row Arm Balance",
                             "B2: Legs - Abs",
                             "B2: Shoulders - Plank Crunch",
                             "T1: Back+Bi - Mountain Climber"]
        
        let tempString = "\(selectedWorkout) - \(exerciseName)"
        
        for i in 0..<xAxisSecArray.count {
            
            if tempString == xAxisSecArray[i] {
                
                return "Sec"
            }
        }
        
        return "Reps"
    }
    
    func findYAxisTitle() -> String {
        
        let yAxisRepsArray = ["B1: Chest+Tri - Dips",
                              "B1: Chest+Tri - Abs",
                              "B1: Back+Bi - Close-Grip Chin-Up",
                              "B1: Back+Bi - Superman to Airplane",
                              "B1: Legs - S-L Calf Raise",
                              "B1: Legs - S Calf Raise",
                              "B1: Legs - Abs",
                              "B2: Chest - Superman Airplane",
                              "B2: Chest - Russian Twist",
                              "B2: Back - Plank Row Arm Balance",
                              "B2: Legs - Abs",
                              "B2: Shoulders - Plank Crunch",
                              "T1: Back+Bi - Mountain Climber"]
        
        let tempString = "\(selectedWorkout) - \(exerciseName)"
        
        for i in 0..<yAxisRepsArray.count {
            
            if tempString == yAxisRepsArray[i] {
                
                return "Reps"
            }
        }
        
        return "Weight"
    }
}
