//
//  WorkoutTVC_CompletionTableViewCell.swift
//  90 DWT BB
//
//  Created by Jared Grant on 7/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutTVC_CompletionTableViewCell: UITableViewCell {

    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var workoutIndex = 0
    var indexPath = NSIndexPath()
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteDateButton: UIButton!
    @IBOutlet weak var todayDateButton: UIButton!
    @IBOutlet weak var previousDateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func workoutCompletedDelete(sender: UIButton) {
        
        CDOperation.deleteDate(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex)
        
        updateWorkoutCompleteCellUI()
    }
    
    @IBAction func workoutCompletedToday(sender: UIButton) {
        
        CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex, useDate: NSDate())
        
        updateWorkoutCompleteCellUI()
    }
    
    @IBAction func workoutCompletedPrevious(sender: UIButton) {
        
//        WorkoutTVC.testFunction(sender, indexPath: indexPath)
//        
//        
//        let popOverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
//        
//        popOverContent.modalPresentationStyle = .Popover
//        
//        let popOver = popOverContent.popoverPresentationController
//        popOver?.sourceView = sender
//        popOver?.sourceRect = sender.bounds
//        popOver?.permittedArrowDirections = .Any
//        popOver?.delegate = self
        
        
        //.presentViewController(popOverContent, animated: true, completion: nil)
//        popOver.popoverPresentationController?.delegate = self
//        popOver.popoverPresentationController?.sourceView = sender
//        popOver.popoverPresentationController?.sourceRect = sender.bounds
//        popOver.popoverPresentationController?.permittedArrowDirections = .Any
        
    }
    
    func updateWorkoutCompleteCellUI () {
        
        let workoutCompletedObjects = CDOperation.getWorkoutCompletedObjects(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex)
        
        switch  workoutCompletedObjects.count {
        case 0:
            // No match
            
            // Cell
            self.backgroundColor = UIColor.whiteColor()
            
            // Label
            dateLabel.text = "Workout Completed: __/__/__";
            dateLabel.textColor = UIColor.blackColor()
            
        default:
            // Found a match.
            
            let object = workoutCompletedObjects.last
            let completedDate = NSDateFormatter .localizedStringFromDate((object?.date)!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
//            getDate = [NSDateFormatter localizedStringFromDate:myDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]
            // Cell
            self.backgroundColor = UIColor.darkGrayColor()
            
            // Label
            dateLabel.text? = "Workout Completed: \(completedDate)"
            dateLabel.textColor = UIColor.whiteColor()
        }
    }
}
