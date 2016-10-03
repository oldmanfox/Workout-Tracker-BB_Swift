///
//  WorkoutTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import Social
import CoreData

class WorkoutTVC: CDTableViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate {

    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var workoutWeek = ""
    var workoutIndex = 0
    
    var selectedCellIdentifier = ""
    var workoutCompleteCell = WorkoutTVC_CompletionTableViewCell()
    
    var exerciseNameArray = [[], []]
    var exerciseRepsArray = [[], []]
    var cellArray = [[], []]
    
    private struct CellType {
        static let workout = "WorkoutCell"
        static let completion = "CompletionCell"
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
    
    private struct Color {
        static let lightGreen = UIColor (red: 8/255, green: 175/255, blue: 90/255, alpha: 1)
        static let mediumGreen = UIColor (red: 4/255, green: 142/255, blue: 93/255, alpha: 1)
        static let darkGreen = UIColor (red: 0/255, green: 110/255, blue: 96/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExerciseNameArray(selectedWorkout)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        // Add rightBarButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(WorkoutTVC.actionButtonPressed(_:)))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doNothing), name: "SomethingChanged", object: nil)
        
        self.tableView.reloadData()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "doNothing", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doNothing() {
        
        // Do nothing
    }

    func actionButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Share", message: "How you want to share your progress?", preferredStyle: .ActionSheet)
        
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: {
            action in
            
            self.sendEmail(CDOperation.singleWorkoutStringForEmail(self.selectedWorkout, index: self.workoutIndex))
        })
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: {
            action in
            
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                //            socialController.setInitialText("Hello World!")
                //            socialController.addImage(someUIImageInstance)
                //            socialController.addURL(someNSURLInstance)
                
                self.presentViewController(socialController, animated: true, completion: nil)
            }
            else {
                
                let alertControllerError = UIAlertController(title: "Error", message: "Please ensure you are connected to the internet AND signed into the Facebook app on your device before posting to Facebook.", preferredStyle: .Alert)
                
                let cancelActionError = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertControllerError.addAction(cancelActionError)
                
                if let popoverError = alertControllerError.popoverPresentationController {
                    
                    popoverError.barButtonItem = sender
                    popoverError.sourceView = self.view
                    popoverError.delegate = self
                    popoverError.permittedArrowDirections = .Any
                }
                
                self.presentViewController(alertControllerError, animated: true, completion: nil)
            }
        })
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: {
            action in
            
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                //            socialController.setInitialText("Hello World!")
                //            socialController.addImage(someUIImageInstance)
                //            socialController.addURL(someNSURLInstance)
                
                self.presentViewController(socialController, animated: true, completion: nil)
            }
            else {
                
                let alertControllerError = UIAlertController(title: "Error", message: "Please ensure you are connected to the internet AND signed into the Twitter app on your device before posting to Twitter.", preferredStyle: .Alert)
                
                let cancelActionError = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertControllerError.addAction(cancelActionError)
                
                if let popoverError = alertControllerError.popoverPresentationController {
                    
                    popoverError.barButtonItem = sender
                    popoverError.sourceView = self.view
                    popoverError.delegate = self
                    popoverError.permittedArrowDirections = .Any
                }
                
                self.presentViewController(alertControllerError, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(emailAction)
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.barButtonItem = sender
            popover.sourceView = self.view
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sendEmail(cvsString: String) {
        
        // Create MailComposerViewController object.
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.navigationBar.tintColor = UIColor.whiteColor()
        
        // Check to see if the device has at least 1 email account configured
        if MFMailComposeViewController.canSendMail() {
            
            // Send email
            let csvData = cvsString.dataUsingEncoding(NSASCIIStringEncoding)
            let subject = "90 DWT BB Workout Data"
            let fileName = NSString .localizedStringWithFormat("%@ - Session %@.csv", self.navigationItem.title!, session)
            var emailAddress = [""]
            
            // Fetch defaultEmail data.
            let request = NSFetchRequest( entityName: "Email")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]
            
            do {
                if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                    
                    print("emailObjects.count = \(emailObjects.count)")
                    
                    if emailObjects.count != 0 {
                        
                        // There is a default email address.
                        emailAddress = [(emailObjects.last?.defaultEmail)!]
                    }
                    else {
                        
                        // There is NOT a default email address.  Put an empty email address in the arrary.
                        emailAddress = [""]
                    }
                }
                
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            mailcomposer.setToRecipients(emailAddress)
            mailcomposer.setSubject(subject as String)
            mailcomposer.addAttachmentData(csvData!, mimeType: "text/csv", fileName: fileName as String)
            
            presentViewController(mailcomposer, animated: true, completion: {
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return cellArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return cellArray[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let workoutObject = cellArray[indexPath.section][indexPath.row] as? NSArray {
            
            if let cellIdentifierArray = workoutObject[5] as? [String] {
                
                let cellIdentifier = cellIdentifierArray[0]
                
                if cellIdentifier == "WorkoutCell" {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_WorkoutTableViewCell
                    
                    let titleArray = workoutObject[0] as? NSArray
                    cell.title.text = titleArray![0].uppercaseString
                    cell.nonUpperCaseExerciseName = titleArray![0] as! String
                    
                    cell.workoutRoutine = workoutRoutine // Bulk or Tone
                    cell.selectedWorkout = selectedWorkout // B1: Chest+Tri etc...
                    cell.workoutIndex = workoutIndex // Index of the workout in the program
                    cell.session = session
                    cell.workoutWeek = workoutWeek

                    if let repNumbers = workoutObject[1] as? [String] {
                        
                        cell.repNumberLabel1.text = repNumbers[0]
                        cell.repNumberLabel2.text = repNumbers[1]
                        cell.repNumberLabel3.text = repNumbers[2]
                        cell.repNumberLabel4.text = repNumbers[3]
                        cell.repNumberLabel5.text = repNumbers[4]
                        cell.repNumberLabel6.text = repNumbers[5]
                    }
                    
                    if let repTitles = workoutObject[2] as? [String] {
                        
                        cell.repTitleLabel1.text = repTitles[0]
                        cell.repTitleLabel2.text = repTitles[1]
                        cell.repTitleLabel3.text = repTitles[2]
                        cell.repTitleLabel4.text = repTitles[3]
                        cell.repTitleLabel5.text = repTitles[4]
                        cell.repTitleLabel6.text = repTitles[5]
                    }
                    
                    if let cellColor = workoutObject[3] as? [UIColor] {
                        
                        cell.currentWeight1.backgroundColor = cellColor[0]
                        cell.currentWeight2.backgroundColor = cellColor[1]
                        cell.currentWeight3.backgroundColor = cellColor[2]
                        cell.currentWeight4.backgroundColor = cellColor[3]
                        cell.currentWeight5.backgroundColor = cellColor[4]
                        cell.currentWeight6.backgroundColor = cellColor[5]
                    }
                    
                    if let weightFields = workoutObject[4] as? [Bool] {
                        
                        cell.previousWeight1.hidden = weightFields[0]
                        cell.previousWeight2.hidden = weightFields[1]
                        cell.previousWeight3.hidden = weightFields[2]
                        cell.previousWeight4.hidden = weightFields[3]
                        cell.previousWeight5.hidden = weightFields[4]
                        cell.previousWeight6.hidden = weightFields[5]
                        
                        cell.currentWeight1.hidden = weightFields[0]
                        cell.currentWeight2.hidden = weightFields[1]
                        cell.currentWeight3.hidden = weightFields[2]
                        cell.currentWeight4.hidden = weightFields[3]
                        cell.currentWeight5.hidden = weightFields[4]
                        cell.currentWeight6.hidden = weightFields[5]
                    }
                    
                    cell.currentWeight1.text = "0.0"
                    cell.currentWeight2.text = "0.0"
                    cell.currentWeight3.text = "0.0"
                    cell.currentWeight4.text = "0.0"
                    cell.currentWeight5.text = "0.0"
                    cell.currentWeight6.text = "0.0"
                    cell.currentNotes.text = "CURRENT NOTES"
                    
                    cell.originalCurrentWeight1_Text = "0.0"
                    cell.originalCurrentWeight2_Text = "0.0"
                    cell.originalCurrentWeight3_Text = "0.0"
                    cell.originalCurrentWeight4_Text = "0.0"
                    cell.originalCurrentWeight5_Text = "0.0"
                    cell.originalCurrentWeight6_Text = "0.0"
                    cell.originalCurrentNotes_Text = "CURRENT NOTES"
                    
                    cell.previousWeight1.text = "0.0"
                    cell.previousWeight2.text = "0.0"
                    cell.previousWeight3.text = "0.0"
                    cell.previousWeight4.text = "0.0"
                    cell.previousWeight5.text = "0.0"
                    cell.previousWeight6.text = "0.0"
                    cell.previousNotes.text = "PREVIOUS NOTES"
                    
                    // Current Weight Fields and Notes
                    if let workoutObjects = CDOperation.getWeightTextForExercise(session, routine: workoutRoutine, workout: selectedWorkout, exercise: titleArray![0] as! String, index: workoutIndex)  as? [Workout] {
                        
                        print("Objects in array: \(workoutObjects.count)")
                        
                        for object in workoutObjects {
                            
                            var tempWeight = ""
                            
                            if object.weight != nil {
                                
                                tempWeight = object.weight!
                            }
                            else {
                                
                                tempWeight = "0.0"
                            }
                            
                            print("Round = \(object.round!) - Weight = \(tempWeight)")
                        }
                        
                        if workoutObjects.count != 0 {
                            
                            for object in workoutObjects {
                                
                                switch object.round as! Int {
                                case 0:
                                    if object.weight != nil {
                                        
                                        cell.currentWeight1.text = object.weight
                                        cell.originalCurrentWeight1_Text = object.weight!
                                    }
                                    else {
                                        cell.currentWeight1.text = "0.0"
                                        cell.originalCurrentWeight1_Text = "0.0"
                                    }
                                    
                                case 1:
                                    if object.weight != nil {
                                       
                                        cell.currentWeight2.text = object.weight
                                        cell.originalCurrentWeight2_Text = object.weight!
                                    }
                                    else {
                                        
                                        cell.currentWeight2.text = "0.0"
                                        cell.originalCurrentWeight2_Text = "0.0"
                                    }
                                    
                                case 2:
                                    if object.weight != nil {
                                        
                                        cell.currentWeight3.text = object.weight
                                        cell.originalCurrentWeight3_Text = object.weight!
                                    }
                                    else {
                                        
                                        cell.currentWeight3.text = "0.0"
                                        cell.originalCurrentWeight3_Text = "0.0"
                                    }
                                    
                                case 3:
                                    if object.weight != nil {
                                        
                                        cell.currentWeight4.text = object.weight
                                        cell.originalCurrentWeight4_Text = object.weight!
                                    }
                                    else {
                                        
                                        cell.currentWeight4.text = "0.0"
                                        cell.originalCurrentWeight4_Text = "0.0"
                                    }
                                    
                                case 4:
                                    if object.weight != nil {
                                        
                                        cell.currentWeight5.text = object.weight
                                        cell.originalCurrentWeight5_Text = object.weight!
                                    }
                                    else {
                                        
                                        cell.currentWeight5.text = "0.0"
                                        cell.originalCurrentWeight5_Text = "0.0"
                                    }
                                    
                                case 5:
                                    if object.weight != nil {
                                        
                                        cell.currentWeight6.text = object.weight
                                        cell.originalCurrentWeight6_Text = object.weight!
                                        
                                    }
                                    else {
                                        
                                        cell.currentWeight6.text = "0.0"
                                        cell.originalCurrentWeight6_Text = "0.0"
                                    }
                                    
                                    if object.notes != nil {
                                        
                                        cell.currentNotes.text = object.notes?.uppercaseString
                                        cell.originalCurrentNotes_Text = object.notes!.uppercaseString
                                    }
                                    else {
                                        
                                        cell.currentNotes.text = "CURRENT NOTES"
                                        cell.originalCurrentNotes_Text = "CURRENT NOTES"
                                    }
                                    
                                default:
                                    break
                                }
                            }
                        }
                    }

                    // Previous Weight Fields and Notes
                    if let workoutObjects = CDOperation.getWeightTextForExercise(session, routine: workoutRoutine, workout: selectedWorkout, exercise: titleArray![0] as! String, index: workoutIndex - 1)  as? [Workout] {
                        
                        print("Objects in array: \(workoutObjects.count)")
                        
                        for object in workoutObjects {
                            
                            var tempWeight = ""
                            
                            if object.weight != nil {
                                
                                tempWeight = object.weight!
                            }
                            else {
                                
                                tempWeight = "0.0"
                            }

                            print("Round = \(object.round!) - Weight = \(tempWeight)")
                        }
                        
                        if workoutObjects.count != 0 {
                            
                            for object in workoutObjects {
                                
                                switch object.round as! Int {
                                case 0:
                                    cell.previousWeight1.text = object.weight
                                    
                                case 1:
                                    cell.previousWeight2.text = object.weight
                                    
                                case 2:
                                    cell.previousWeight3.text = object.weight
                                    
                                case 3:
                                    cell.previousWeight4.text = object.weight
                                    
                                case 4:
                                    cell.previousWeight5.text = object.weight
                                    
                                case 5:
                                    cell.previousWeight6.text = object.weight
                                    cell.previousNotes.text = object.notes?.uppercaseString
                                    
                                default:
                                    break
                                }
                            }
                        }
                    }
                    
                    return cell
                }
                else {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_CompletionTableViewCell
                    
                    cell.workoutRoutine = workoutRoutine // Bulk or Tone
                    cell.selectedWorkout = selectedWorkout // B1: Chest+Tri etc...
                    cell.workoutIndex = workoutIndex // Index of the workout in the program
                    cell.session = session
                    cell.indexPath = indexPath

                    cell.updateWorkoutCompleteCellUI()
                    
                    cell.previousDateButton.addTarget(self, action: #selector(WorkoutTVC.previousButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    
                    workoutCompleteCell = cell
                    
                    return cell
                }
            }
        }
        
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
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if selectedCellIdentifier == "PreviousButtonPressed" {
            
            workoutCompleteCell.updateWorkoutCompleteCellUI()
        }
    }
    
    @IBAction func previousButtonPressed(sender: UIButton) {
        
        print("Previous Button Pressed")
        
        selectedCellIdentifier = "PreviousButtonPressed"
        
        let popOverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        
        popOverContent.session = session
        popOverContent.workoutRoutine = workoutRoutine
        popOverContent.selectedWorkout = selectedWorkout
        popOverContent.workoutIndex = workoutIndex
        
        popOverContent.modalPresentationStyle = .Popover
        
        let popOver = popOverContent.popoverPresentationController
        popOver?.sourceView = sender
        popOver?.sourceRect = sender.bounds
        popOver?.permittedArrowDirections = .Any
        popOver?.delegate = self
        
        presentViewController(popOverContent, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowShinobiChart" {
            
            let destinationNavController = segue.destinationViewController as? UINavigationController
            let destinationVC = destinationNavController?.topViewController as! ExerciseChartViewController
            
            destinationVC.session = session
            destinationVC.workoutRoutine = workoutRoutine
            destinationVC.selectedWorkout = selectedWorkout
            destinationVC.workoutIndex = workoutIndex
            
            let button = sender as! UIButton
            let view = button.superview
            let cell = view?.superview as! WorkoutTVC_WorkoutTableViewCell
            
            destinationVC.exerciseName = cell.nonUpperCaseExerciseName
            destinationVC.navigationItem.title = selectedWorkout
            
            let graphDataPoints = [cell.repNumberLabel1.text,
                                   cell.repNumberLabel2.text,
                                   cell.repNumberLabel3.text,
                                   cell.repNumberLabel4.text,
                                   cell.repNumberLabel5.text,
                                   cell.repNumberLabel6.text]
            
            destinationVC.graphDataPoints = graphDataPoints
            
            let exerciseName = cell.nonUpperCaseExerciseName
            print("Exercise Name = \(exerciseName)")
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func loadExerciseNameArray(workout: String) {
        
        switch workout {
        case "B1: Chest+Tri":
            
            let cell1 = [["Dumbbell Chest Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Incline Dumbbell Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Incline Dumbbell Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Close Grip Dumbbell Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Partial Dumbbell Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Decline Push-Up"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Laying Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Single Arm Tricep Kickback"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell9 = [["Diamond Push-Up"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Dips"],
                          [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.sec, Reps.Title.empty , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, true, true, true, true, true],
                          [CellType.workout]]
            
            let cell11 = [["Abs"],
                          [Reps.Number._60, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, true, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7],
                         [cell8, cell9],
                         [cell10, cell11],
                         [completeCell]]
            
        case "B1: Legs":
            
            let cell1 = [["Wide Squat"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Alt Lunge"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["S-U to Reverse Lunge"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell4 = [["P Squat"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["B Squat"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["S-L Deadlift"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["S-L Calf Raise"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["S Calf Raise"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell9 = [["Abs"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7, cell8, cell9],
                         [completeCell]]
            
        case "B1: Back+Bi":
            
            let cell1 = [["Dumbbell Deadlift"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Dumbbell Pull-Over"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Pull-Up"],
                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Curl Bar Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["One-Arm Dumbbell Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Reverse Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Close-Grip Chin-Up"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Seated Bicep Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell9 = [["Hammer Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Curl Bar Bicep Curl"],
                          [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, false, false, true, true],
                          [CellType.workout]]
            
            let cell11 = [["Superman to Airplane"],
                          [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.sec, Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7],
                         [cell8],
                         [cell9],
                         [cell10],
                         [cell11],
                         [completeCell]]
            
        case "B1: Shoulders":
            
            let cell1 = [["Dumbbell Shoulder Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Dumbbell Lateral Raise"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Curl Bar Upright Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Curl Bar Underhand Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Front Raise"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Rear Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Dumbbell Shrug"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Leaning Dumbbell Shrug"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell9 = [["6-Way Shoulder"],
                         [Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Abs"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1],
                         [cell2, cell3],
                         [cell4, cell5, cell6],
                         [cell7, cell8],
                         [cell9, cell10],
                         [completeCell]]
            
        case "B2: Arms":
            
            let cell1 = [["Dumbbell Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell2 = [["Seated Dumbbell Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Curl Bar Curl"],
                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
                         [false, false, false, false, false, true],
                         [CellType.workout]]
            
            let cell4 = [["Laying Curl Bar Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Dumbbell Hammer Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell6 = [["Leaning Dumbbell Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell7 = [["Abs"],
                         [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1],
                         [cell2],
                         [cell3],
                         [cell4],
                         [cell5],
                         [cell6],
                         [cell7],
                         [completeCell]]
            
        case "B2: Legs":
            
            let cell1 = [["2-Way Lunge"],
                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Dumbbell Squat"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell3 = [["2-Way Sumo Squat"],
                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
                         [false, false, false, false, false, true],
                         [CellType.workout]]
            
            let cell4 = [["Curl Bar Split Squat"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell5 = [["S-L Deadlift"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Side to Side Squat"],
                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["S-L Calf Raise"],
                         [Reps.Number._50, Reps.Number._50, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Abs"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1],
                         [cell2],
                         [cell3],
                         [cell4],
                         [cell5, cell6],
                         [cell7, cell8],
                         [completeCell]]
            
        case "B2: Shoulders":
            
            let cell1 = [["Dumbbell Lateral Raise"],
                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Dumbbell Arnold Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Curl Bar Upright Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell4 = [["One Arm Dumbbell Front Raise"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Two Arm Front Raise Rotate"],
                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Reverse Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell7 = [["Plank Opposite Arm Leg Raise"],
                         [Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Plank Crunch"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2],
                         [cell3],
                         [cell4, cell5],
                         [cell6],
                         [cell7, cell8],
                         [completeCell]]
            
        case "B2: Chest":
            
            let cell1 = [["Incline Dumbbell Fly"],
                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Incline Dumbbell Press 1"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Rotating Dumbbell Chest Press"],
                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
                         [false, false, false, false, false, true],
                         [CellType.workout]]
            
            let cell4 = [["Incline Dumbbell Press 2"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell5 = [["Center Dumbbell Chest Press Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Decline Push-Up"],
                         [Reps.Number._12, Reps.Number._10, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Superman Airplane"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Russian Twist"],
                         [Reps.Number.empty, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.empty, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [UIColor.whiteColor(), Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [true, false, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2],
                         [cell3],
                         [cell4],
                         [cell5],
                         [cell6, cell7, cell8],
                         [completeCell]]
            
        case "B2: Back":
            
            let cell1 = [["Dumbbell Pull-Over"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Pull-Up"],
                         [Reps.Number._10, Reps.Number._10, Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Curl Bar Underhand Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number._12, Reps.Number._15],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.darkGreen, Color.mediumGreen, Color.lightGreen],
                         [false, false, false, false, false, false],
                         [CellType.workout]]
            
            let cell4 = [["One Arm Dumbbell Row"],
                         [Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number._5, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, Color.lightGreen, UIColor.whiteColor()],
                         [false, false, false, false, false, true],
                         [CellType.workout]]
            
            let cell5 = [["Deadlift"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number._8, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, false, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Reverse Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Plank Row Arm Balance"],
                         [Reps.Number._30, Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.sec, Reps.Title.sec , Reps.Title.empty  , Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2],
                         [cell3],
                         [cell4],
                         [cell5],
                         [cell6, cell7],
                         [completeCell]]
            
        case "T1: Chest+Tri":
            
            let cell1 = [["Dumbbell Chest Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Crunch 1"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Incline Dumbbell Press"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Crunch 2"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Incline Dumbbell Fly"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Plank To Sphinx"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Curl Bar Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Curl Bar Crunch"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell9 = [["Dumbbell Tricep Extension"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Dips"],
                          [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, false, true, true, true],
                          [CellType.workout]]
            
            let cell11 = [["Plank Crunch"],
                          [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, true, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2],
                         [cell3, cell4],
                         [cell5, cell6],
                         [cell7, cell8],
                         [cell9, cell10, cell11],
                         [completeCell]]
            
        case "T1: Back+Bi":
            
            let cell1 = [["Dumbbell Pull-Over"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Plank Hop"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Pull-Up"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Hanging Side-To-Side Crunch"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Curl Bar Row"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Curl Bar Twist"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Dumbbell Preacher Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Hanging Crunch"],
                         [Reps.Number._10, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, true, true, true, true, true],
                         [CellType.workout]]
            
            let cell9 = [["Curl Bar Multi Curl"],
                         [Reps.Number._15, Reps.Number._12, Reps.Number._8, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.mediumGreen, Color.darkGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, false, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Mountain Climber"],
                          [Reps.Number._30, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.sec, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, true, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2],
                         [cell3, cell4],
                         [cell5, cell6],
                         [cell7, cell8],
                         [cell9, cell10],
                         [completeCell]]
            
        case "B3: Complete Body":
            
            let cell1 = [["Pull-Up"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell2 = [["Push-Up"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell3 = [["Dumbbell Squat"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell4 = [["Crunch"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell5 = [["Dumbell Incline Press"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell6 = [["Dumbell Bent-Over Row"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell7 = [["Dumbell Alt Reverse Lunge"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell8 = [["Plank Crunch"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell9 = [["3-Way Military Press"],
                         [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                         [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                         [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                         [false, false, true, true, true, true],
                         [CellType.workout]]
            
            let cell10 = [["Single Arm Leaning Reverse Fly"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell11 = [["S-L Deadlift"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell12 = [["Russian Twist"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell13 = [["Curl-Up Hammer-Down"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell14 = [["Leaning Tricep Extension"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell15 = [["Calf Raise"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let cell16 = [["Side Sphinx Raise"],
                          [Reps.Number._15, Reps.Number._15, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty, Reps.Number.empty],
                          [Reps.Title.reps, Reps.Title.reps, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty, Reps.Title.empty],
                          [Color.lightGreen, Color.lightGreen, UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()],
                          [false, false, true, true, true, true],
                          [CellType.workout]]
            
            let completeCell = [[],
                                [],
                                [],
                                [],
                                [],
                                [CellType.completion]]
            
            cellArray = [[cell1, cell2, cell3, cell4],
                         [cell5, cell6, cell7, cell8],
                         [cell9, cell10, cell11, cell12],
                         [cell13, cell14, cell15, cell16],
                         [completeCell]]
            
        default:
            break
        }
    }
}