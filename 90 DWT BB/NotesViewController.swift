//
//  NotesViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 8/1/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import Social
import CoreData

class NotesViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate {
    
    var session = ""
    var workoutRoutine = ""
    var selectedWorkout = ""
    var workoutIndex = 0
    var originalNoteText = ""

    @IBOutlet weak var currentNotes: UITextView!
    @IBOutlet weak var previousNotes: UITextView!
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var currentNotesLabel: UILabel!
    @IBOutlet weak var previousNotesLabel: UILabel!
    @IBOutlet weak var shareActionButton: UIBarButtonItem!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteDateButton: UIButton!
    @IBOutlet weak var todayDateButton: UIButton!
    @IBOutlet weak var previousDateButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currentNotes.delegate = self
        
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doNothing), name: "SomethingChanged", object: nil)
        
        self.roundLabel.hidden = true
        
        // Apply Border to TextViews
        self.currentNotes.layer.borderWidth = 0.5
        self.currentNotes.layer.borderColor = UIColor.lightGrayColor().CGColor
        //self.currentNotes.layer.cornerRadius = 5
        self.currentNotes.clipsToBounds = true
        
        self.previousNotes.layer.borderWidth = 0.5
        self.previousNotes.layer.borderColor = UIColor.lightGrayColor().CGColor
        //self.previousNotes.layer.cornerRadius = 5
        self.previousNotes.clipsToBounds = true
        
        // Get data to display in the textfields
        // Current textfield
        currentNotes.text = CDOperation.getNotesTextForRound(session, routine: workoutRoutine, workout: selectedWorkout, round: 1, index: workoutIndex)
        self.originalNoteText = currentNotes.text
        
        // Previous textfield
        previousNotes.text = CDOperation.getNotesTextForRound(session, routine: workoutRoutine, workout: selectedWorkout, round: 1, index: workoutIndex - 1)
        
        updateWorkoutCompleteCellUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        saveNote()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "doNothing", object: nil)
    }
    
    func doNothing() {
        
        // Do nothing
    }
    
    func saveNote() {
        
        if currentNotes.text != "" && currentNotes.text != originalNoteText {
            
            CDOperation.saveNoteWithPredicateNoExercise(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex, note: currentNotes.text, round: 1)
        }
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        saveNote()
        
        let alertController = UIAlertController(title: "Share", message: "", preferredStyle: .ActionSheet)
        
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: {
            action in
            
            self.emailResults()
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
    
    @IBAction func deleteDateButtonPressed(sender: UIButton) {
        
        CDOperation.deleteDate(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex)
        
        updateWorkoutCompleteCellUI()
    }
    
    @IBAction func todayDateButtonPressed(sender: UIButton) {
        
        CDOperation.saveWorkoutCompleteDate(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex, useDate: NSDate())
        
        updateWorkoutCompleteCellUI()
    }
    
    @IBAction func previousDateButtonPressed(sender: UIButton) {
        
        print("Previous Button Pressed")
        
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
    
    func updateWorkoutCompleteCellUI () {
        
        let workoutCompletedObjects = CDOperation.getWorkoutCompletedObjects(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex)
        
        switch  workoutCompletedObjects.count {
        case 0:
            // No match
            
            // Cell
            datePickerView.backgroundColor = UIColor.whiteColor()
            
            // Label
            dateLabel.text = "Workout Completed: __/__/__";
            dateLabel.textColor = UIColor.blackColor()
            
        default:
            // Found a match.
            
            let object = workoutCompletedObjects.last
            let completedDate = NSDateFormatter .localizedStringFromDate((object?.date)!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            
            // Cell
            datePickerView.backgroundColor = UIColor.darkGrayColor()
            
            // Label
            dateLabel.text? = "Workout Completed: \(completedDate)"
            dateLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        updateWorkoutCompleteCellUI()
    }
    
    func emailResults() {
    
        // Create MailComposerViewController object.
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.navigationBar.tintColor = UIColor.whiteColor()
        
        // Check to see if the device has at least 1 email account configured
        if MFMailComposeViewController.canSendMail() {
            
            // Get the objects for the current session
            let workoutObjects = CDOperation.getNoteObjects(session, routine: workoutRoutine, workout: selectedWorkout, index: workoutIndex)
            
            let writeString = NSMutableString()
            
            if workoutObjects.count != 0 {
                
                writeString.appendString("Session,Routine,Month,Week,Workout,Notes,Date\n")
                
                for i in 0..<workoutObjects.count {
                    
                    let session = workoutObjects[i].session
                    let routine = workoutObjects[i].routine;
                    let month = workoutObjects[i].month;
                    let week  = workoutObjects[i].week;
                    let workout = workoutObjects[i].workout;
                    let notes = workoutObjects[i].notes;
                    let date = workoutObjects[i].date;

                    let dateString = NSDateFormatter.localizedStringFromDate(date!, dateStyle: .ShortStyle, timeStyle: .NoStyle)
                    
                    writeString.appendString("\(session!),\(routine!),\(month),\(week),\(workout!),\(notes!),\(dateString)\n")
                }
            }
            
            // Send email
            
            let csvData = writeString.dataUsingEncoding(NSASCIIStringEncoding)
            let workoutName = selectedWorkout.stringByAppendingString(".csv")
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
            mailcomposer.setSubject("90 DWT BB Workout Data")
            mailcomposer.addAttachmentData(csvData!, mimeType: "text/csv", fileName: workoutName)
            
            presentViewController(mailcomposer, animated: true, completion: nil)
        }
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        currentNotes.resignFirstResponder()
        
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            currentNotes.resignFirstResponder()
            saveNote()
            return false
        }
        
        return true
    }
    
    @IBAction func hideKeyboard(sender: UIButton) {
        
        self.currentNotes.resignFirstResponder()
        saveNote()
    }

}
