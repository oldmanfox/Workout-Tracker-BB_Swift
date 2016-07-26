//
//  DatePickerViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 7/15/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var workoutIndex = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let chosen = datePicker.date
        
        print("Date: \(chosen)")
        
        CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex, useDate: chosen)

    }
}
