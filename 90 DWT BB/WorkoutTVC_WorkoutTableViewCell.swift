//
//  WorkoutTVC_WorkoutTableViewCell.swift
//  90 DWT BB
//
//  Created by Jared Grant on 7/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutTVC_WorkoutTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var title: UILabel!
    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var workoutWeek = ""
    var nonUpperCaseExerciseName = ""
    var workoutIndex = 0
        
    var originalCurrentWeight1_Text = ""
    var originalCurrentWeight2_Text = ""
    var originalCurrentWeight3_Text = ""
    var originalCurrentWeight4_Text = ""
    var originalCurrentWeight5_Text = ""
    var originalCurrentWeight6_Text = ""
    var originalCurrentNotes_Text = ""
    
    var activeTextField = UITextField()
    
    @IBOutlet weak var repNumberLabel1: UILabel!
    @IBOutlet weak var repNumberLabel2: UILabel!
    @IBOutlet weak var repNumberLabel3: UILabel!
    @IBOutlet weak var repNumberLabel4: UILabel!
    @IBOutlet weak var repNumberLabel5: UILabel!
    @IBOutlet weak var repNumberLabel6: UILabel!
    
    @IBOutlet weak var repTitleLabel1: UILabel!
    @IBOutlet weak var repTitleLabel2: UILabel!
    @IBOutlet weak var repTitleLabel3: UILabel!
    @IBOutlet weak var repTitleLabel4: UILabel!
    @IBOutlet weak var repTitleLabel5: UILabel!
    @IBOutlet weak var repTitleLabel6: UILabel!
    
    @IBOutlet weak var previousWeight1: UITextField!
    @IBOutlet weak var previousWeight2: UITextField!
    @IBOutlet weak var previousWeight3: UITextField!
    @IBOutlet weak var previousWeight4: UITextField!
    @IBOutlet weak var previousWeight5: UITextField!
    @IBOutlet weak var previousWeight6: UITextField!
    
    @IBOutlet weak var currentWeight1: UITextField!
    @IBOutlet weak var currentWeight2: UITextField!
    @IBOutlet weak var currentWeight3: UITextField!
    @IBOutlet weak var currentWeight4: UITextField!
    @IBOutlet weak var currentWeight5: UITextField!
    @IBOutlet weak var currentWeight6: UITextField!
    
    @IBOutlet weak var previousNotes: UITextField!
    @IBOutlet weak var currentNotes: UITextField!
    
    @IBOutlet weak var graphButton: UIButton!
    
    
    @IBAction func saveCurrentWeight1(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight1_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 0, reps: self.repNumberLabel1.text!)
        }
        else {
            
            sender.text = originalCurrentWeight1_Text
        }
    }
    
    @IBAction func saveCurrentWeight2(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight2_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 1, reps: self.repNumberLabel2.text!)
        }
        else {
            
            sender.text = originalCurrentWeight2_Text
        }
    }
    
    @IBAction func saveCurrentWeight3(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight3_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 2, reps: self.repNumberLabel3.text!)
        }
        else {
            
            sender.text = originalCurrentWeight3_Text
        }
    }
    
    @IBAction func saveCurrentWeight4(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight4_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 3, reps: self.repNumberLabel4.text!)
        }
        else {
            
            sender.text = originalCurrentWeight4_Text
        }
    }
    
    @IBAction func saveCurrentWeight5(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight5_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 4, reps: self.repNumberLabel5.text!)
        }
        else {
            
            sender.text = originalCurrentWeight5_Text
        }
    }
    
    @IBAction func saveCurrentWeight6(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "0.0" && sender.text != originalCurrentWeight6_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveWeightWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , weight: sender.text!, round: 5, reps: self.repNumberLabel6.text!)
        }
        else {
            
            sender.text = originalCurrentWeight6_Text
        }
    }
    
    @IBAction func saveCurrentNotes(sender: UITextField) {
        
        // Only update the fields that have been changed.
        if (sender.text?.characters.count > 0 && sender.text != "CURRENT NOTES" && sender.text != originalCurrentNotes_Text) {
            
            print("String is: \(sender.text!)")
            
            CDOperation.saveNoteWithPredicate(session, routine: workoutRoutine, workout: selectedWorkout, week: workoutWeek, exercise: nonUpperCaseExerciseName, index: workoutIndex , note: sender.text!, round: 5)
        }
        else {
            
            sender.text = originalCurrentNotes_Text
        }
    }
    
    @IBAction func graphButtonPressed(sender: UIButton) {
        
        switch self.activeTextField.tag {
        case 0:
            saveCurrentWeight1(currentWeight1)
            
        case 1:
            saveCurrentWeight2(currentWeight2)
            
        case 2:
            saveCurrentWeight3(currentWeight3)
            
        case 3:
            saveCurrentWeight4(currentWeight4)
            
        case 4:
            saveCurrentWeight5(currentWeight5)
            
        case 5:
            saveCurrentWeight6(currentWeight6)
            
        case 6:
            saveCurrentNotes(currentNotes)
            
        default:
            break
        }
}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        currentWeight1.delegate = self
        currentWeight2.delegate = self
        currentWeight3.delegate = self
        currentWeight4.delegate = self
        currentWeight5.delegate = self
        currentWeight6.delegate = self
        currentNotes.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UITextFieldDelegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        currentWeight1.resignFirstResponder()
        currentWeight2.resignFirstResponder()
        currentWeight3.resignFirstResponder()
        currentWeight4.resignFirstResponder()
        currentWeight5.resignFirstResponder()
        currentWeight6.resignFirstResponder()
        currentNotes.resignFirstResponder()
        
        return true
    }
}
