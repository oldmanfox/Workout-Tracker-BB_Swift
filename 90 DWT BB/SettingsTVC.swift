//
//  SettingsTVC.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 9/21/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData

class SettingsTVC: UITableViewController, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var routineCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var autoLockCell: UITableViewCell!
    @IBOutlet weak var currentSessionCell: UITableViewCell!
    @IBOutlet weak var exportCell: UITableViewCell!
    @IBOutlet weak var resetCell: UITableViewCell!
    @IBOutlet weak var iCloudDriveCell: UITableViewCell!
    @IBOutlet weak var appUsingiCloudCell: UITableViewCell!
    @IBOutlet weak var versionCell: UITableViewCell!
    @IBOutlet weak var websiteCell: UITableViewCell!
    
    @IBOutlet weak var defaultRoutine: UISegmentedControl! // Bulk or Tone.  Default is Bulk.
    @IBOutlet weak var emailDetail: UILabel! // Default is youremail@abc.com.
    @IBOutlet weak var autoLockSwitch: UISwitch! // Disable autolock while using the app.
    @IBOutlet weak var currentSessionLabel: UILabel!
    @IBOutlet weak var decreaseSessionButton: UIButton!
    @IBOutlet weak var increaseSessionButton: UIButton!
    @IBOutlet weak var exportAllDataButton: UIButton!
    @IBOutlet weak var exportCurrentSessionDataButton: UIButton!
    @IBOutlet weak var resetAllDataButton: UIButton!
    @IBOutlet weak var resetCurrentSessionDataButton: UIButton!
    @IBOutlet weak var iCloudDriveStatusLabel: UILabel!
    @IBOutlet weak var iCloudAppStatusLabel: UILabel!
    
    var session = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.configureButtonBorder()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get the current session
        session = CDOperation.getCurrentSession()
        self.currentSessionLabel.text = self.session
        
        self.findRoutineSetting()
        self.findUseAutoLockSetting()
        self.findEmailSetting()
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
    
    func doNothing() {
        
        // Do nothing
    }

    func configureButtonBorder() {
        
        let red = UIColor(red: 175/255, green: 89/255, blue: 8/255, alpha: 1)
        //let lightRed = UIColor(red: 175/255, green: 89/255, blue: 8/255, alpha: 0.75)
        
        // decreaseSession Button
        self.decreaseSessionButton.tintColor = UIColor.whiteColor()
        self.decreaseSessionButton.backgroundColor = red
        self.decreaseSessionButton.layer.borderWidth = 1
        self.decreaseSessionButton.layer.borderColor = red.CGColor
        self.decreaseSessionButton.layer.cornerRadius = 5
        self.decreaseSessionButton.clipsToBounds = true
        
        // increaseSession Button
        self.increaseSessionButton.tintColor = UIColor.whiteColor()
        self.increaseSessionButton.backgroundColor = red
        self.increaseSessionButton.layer.borderWidth = 1
        self.increaseSessionButton.layer.borderColor = red.CGColor
        self.increaseSessionButton.layer.cornerRadius = 5
        self.increaseSessionButton.clipsToBounds = true
        
        // ResetAllData Button
        self.resetAllDataButton.tintColor = UIColor.whiteColor()
        self.resetAllDataButton.backgroundColor = red
        self.resetAllDataButton.layer.borderWidth = 1
        self.resetAllDataButton.layer.borderColor = red.CGColor
        self.resetAllDataButton.layer.cornerRadius = 5
        self.resetAllDataButton.clipsToBounds = true
        
        // ResetCurrentSessionData Button
        self.resetCurrentSessionDataButton.tintColor = UIColor.whiteColor()
        self.resetCurrentSessionDataButton.backgroundColor = red
        self.resetCurrentSessionDataButton.layer.borderWidth = 1
        self.resetCurrentSessionDataButton.layer.borderColor = red.CGColor
        self.resetCurrentSessionDataButton.layer.cornerRadius = 5
        self.resetCurrentSessionDataButton.clipsToBounds = true
        
        // ExportAllData Button
        self.exportAllDataButton.tintColor = UIColor.whiteColor()
        self.exportAllDataButton.backgroundColor = red
        self.exportAllDataButton.layer.borderWidth = 1
        self.exportAllDataButton.layer.borderColor = red.CGColor
        self.exportAllDataButton.layer.cornerRadius = 5
        self.exportAllDataButton.clipsToBounds = true
        
        // ExportCurrentSessionData Button
        self.exportCurrentSessionDataButton.tintColor = UIColor.whiteColor()
        self.exportCurrentSessionDataButton.backgroundColor = red
        self.exportCurrentSessionDataButton.layer.borderWidth = 1
        self.exportCurrentSessionDataButton.layer.borderColor = red.CGColor
        self.exportCurrentSessionDataButton.layer.cornerRadius = 5
        self.exportCurrentSessionDataButton.clipsToBounds = true
    }
    
    @IBAction func selectDefaultRoutine(sender: UISegmentedControl) {
        
        // Fetch Routine data.
        let request = NSFetchRequest( entityName: "Routine")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let routineObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Routine] {
                
                print("routineObjects.count = \(routineObjects.count)")
                
                if routineObjects.count != 0 {
                    
                    // Match Found.  Update existing record.
                    routineObjects.last?.defaultRoutine = self.defaultRoutine.titleForSegmentAtIndex(self.defaultRoutine.selectedSegmentIndex)
                }
                else {
                    
                    // No Matches Found.  Create new record and save.
                    let insertRoutineInfo = NSEntityDescription.insertNewObjectForEntityForName("Routine", inManagedObjectContext: CDHelper.shared.context) as! Routine
                    
                    insertRoutineInfo.defaultRoutine = self.defaultRoutine.titleForSegmentAtIndex(self.defaultRoutine.selectedSegmentIndex)
                    insertRoutineInfo.date = NSDate()
                }
                
                CDHelper.saveSharedContext()
                
                let parentTBC = self.tabBarController as! MainTBC
                parentTBC.routineChangedForNC = true
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    @IBAction func toggleAutoLock(sender: UISwitch) {
        
        var newAutoLockSetting = "OFF"
        
        if sender.on {
            
            // User wants to disable the autolock timer.
            newAutoLockSetting = "ON"
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
        else {
            
            // User doesn't want to disable the autolock timer.
            newAutoLockSetting = "OFF"
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
        
        // Fetch AutoLock data.
        let request = NSFetchRequest( entityName: "AutoLock")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let autoLockObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [AutoLock] {
                
                print("autoLockObjects.count = \(autoLockObjects.count)")
                
                if autoLockObjects.count != 0 {
                    
                    // Match Found.  Update existing record.
                    autoLockObjects.last?.useAutoLock = newAutoLockSetting
                }
                else {
                    
                    // No Matches Found.  Create new record and save.
                    let insertAutoLockInfo = NSEntityDescription.insertNewObjectForEntityForName("AutoLock", inManagedObjectContext: CDHelper.shared.context) as! AutoLock
                    
                    insertAutoLockInfo.useAutoLock = newAutoLockSetting
                    insertAutoLockInfo.date = NSDate()
                }
                
                CDHelper.saveSharedContext()
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    @IBAction func decreaseSession(sender: UIButton) {
        
        let currentSession = CDOperation.getCurrentSession()
        
        var alertController = UIAlertController()
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        if currentSession == "1" {
            
            alertController = UIAlertController(title: "ERROR", message: "Session cannot = 0.", preferredStyle: .Alert)
        }
        else {
            
            alertController = UIAlertController(title: "WARNING - Start Previous Session", message: "Starting a previous session means you will only be able to edit the previous session.  To get to a different session click the \"+\" or \"-\" button after selecting Proceed.", preferredStyle: .Alert)
            
            let proceed = UIAlertAction(title: "Proceed", style: .Default, handler: {
                action in
                
                // Fetch Session data.
                let request = NSFetchRequest( entityName: "Session")
                let sortDate = NSSortDescriptor( key: "date", ascending: true)
                request.sortDescriptors = [sortDate]
                
                do {
                    if let sessionObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Session] {
                        
                        print("sessionObjects.count = \(sessionObjects.count)")
                        
                        if sessionObjects.count != 0 {
                            
                            // Match Found.  Update existing record.
                            let newSessionNumber = Int(self.session)! - 1
                            sessionObjects.last?.currentSession = String(newSessionNumber)
                            sessionObjects.last?.date = NSDate()
                            
                            CDHelper.saveSharedContext()
                            
                            // Update currentSessionLabel
                            self.currentSessionLabel.text = String(newSessionNumber)
                            self.session = String(newSessionNumber)
                            
                            // Session changed
                            let parentTBC = self.tabBarController as! MainTBC
                            parentTBC.sessionChangedForNC = true
                        }
                    }
                    
                } catch { print(" ERROR executing a fetch request: \( error)") }
            })
            
            alertController.addAction(proceed)
        }
        
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func increaseSession(sender: UIButton) {
        
        let alertController = UIAlertController(title: "WARNING - Start New Session", message: "Starting a new session means you will only be able to edit the new session.  To get to a different session click the \"+\" or \"-\" button after selecting Proceed.", preferredStyle: .Alert)
        
        let proceed = UIAlertAction(title: "Proceed", style: .Default, handler: {
            action in
            
            // Fetch Session data.
            let request = NSFetchRequest( entityName: "Session")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]
            
            do {
                if let sessionObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Session] {
                    
                    print("sessionObjects.count = \(sessionObjects.count)")
                    
                    if sessionObjects.count != 0 {
                        
                        // Match Found.  Update existing record.
                        let newSessionNumber = Int(self.session)! + 1
                        sessionObjects.last?.currentSession = String(newSessionNumber)
                        sessionObjects.last?.date = NSDate()
                        
                        CDHelper.saveSharedContext()
                        
                        // Update currentSessionLabel
                        self.currentSessionLabel.text = String(newSessionNumber)
                        self.session = String(newSessionNumber)
                        
                        // Session changed
                        let parentTBC = self.tabBarController as! MainTBC
                        parentTBC.sessionChangedForNC = true
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
        })
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(proceed)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .Any
    }
    
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func exportAllData(sender: UIButton) {
        
        //  Get the ALL SESSIONS csvstring and then send the email
        self.sendEmail("All", cvsString: CDOperation.allSessionStringForEmail())
    }

    @IBAction func exportCurrentSessionData(sender: UIButton) {
        
        //  Get the CURRENT SESSION csvstring and then send the email
        self.sendEmail("Current", cvsString: CDOperation.currentSessionStringForEmail())
    }

    @IBAction func resetAllData(sender: UIButton) {
        
        let alertController = UIAlertController(title: "WARNING - Delete All Data", message: "You are about to delete ALL data in the app and start fresh.  If you are signed into iCloud this will delete the data there as well.", preferredStyle: .Alert)
        
        let proceed = UIAlertAction(title: "Proceed", style: .Default, handler: {
            action in
            
            // Fetch Workout data.
            var request = NSFetchRequest( entityName: "Workout")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]
            
            do {
                if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                    
                    print("workoutObjects.count = \(workoutObjects.count)")
                    
                    for object in workoutObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
           
            // DELETE all from entity - WorkoutCompleteDate
            request = NSFetchRequest(entityName: "WorkoutCompleteDate")
            
            do {
                if let workoutCompleteDateObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [WorkoutCompleteDate] {
                    
                    print("workoutCompleteDateObjects.count = \(workoutCompleteDateObjects.count)")
                    
                    for object in workoutCompleteDateObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // DELETE all from entity - Session
            request = NSFetchRequest(entityName: "Session")
            
            do {
                if let sessionObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Session] {
                    
                    print("sessionObjects.count = \(sessionObjects.count)")
                    
                    for object in sessionObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // Set session to default - 1
            do {
                if let sessionObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Session] {
                    
                    print("sessionObjects.count = \(sessionObjects.count)")
                    
                    if sessionObjects.count == 0 {
                        
                        self.session = CDOperation.getCurrentSession()
                        self.currentSessionLabel.text = self.session
                        
                        // Session changed
                        let parentTBC = self.tabBarController as! MainTBC
                        parentTBC.sessionChangedForNC = true
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // DELETE all from entity - Photo
            request = NSFetchRequest(entityName: "Photo")
            
            do {
                if let photoObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Photo] {
                    
                    print("photoObjects.count = \(photoObjects.count)")
                    
                    for object in photoObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // DELETE all from entity - Measurement
            request = NSFetchRequest(entityName: "Measurement")
            
            do {
                if let measurementObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Measurement] {
                    
                    print("measurementObjects.count = \(measurementObjects.count)")
                    
                    for object in measurementObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }

            // DELETE all from entity - Routine
            request = NSFetchRequest(entityName: "Routine")
            
            do {
                if let routineObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Routine] {
                    
                    print("routineObjects.count = \(routineObjects.count)")
                    
                    for object in routineObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // Set routine to default - Bulk
            do {
                if let routineObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Routine] {
                    
                    print("routineObjects.count = \(routineObjects.count)")
                    
                    if routineObjects.count == 0 {
                        
                        self.defaultRoutine.selectedSegmentIndex = 1
                        CDOperation.getCurrentRoutine()
                        
                        // Default routine changed
                        let parentTBC = self.tabBarController as! MainTBC
                        parentTBC.routineChangedForNC = true
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }

            // DELETE all from entity - Email
            request = NSFetchRequest(entityName: "Email")
            
            do {
                if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                    
                    print("emailObjects.count = \(emailObjects.count)")
                    
                    for object in emailObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // Set email to default
            do {
                if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                    
                    print("emailObjects.count = \(emailObjects.count)")
                    
                    if emailObjects.count == 0 {
                        
                        // No Matches.  Create new record and save.
                        let insertEmailInfo = NSEntityDescription.insertNewObjectForEntityForName("Email", inManagedObjectContext: CDHelper.shared.context) as! Email
                        
                        insertEmailInfo.defaultEmail = "youremail@abc.com"
                        insertEmailInfo.date = NSDate()
                        
                        self.emailDetail.text = "youremail@abc.com"
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }

            // DELETE all from entity - AutoLock
            request = NSFetchRequest(entityName: "AutoLock")
            
            do {
                if let autoLockObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [AutoLock] {
                    
                    print("autoLockObjects.count = \(autoLockObjects.count)")
                    
                    for object in autoLockObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // Set disable autolock to default - OFF
            self.autoLockSwitch.setOn(false, animated: true)
            UIApplication.sharedApplication().idleTimerDisabled = false
            
            // Save data to database
            CDHelper.saveSharedContext()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(proceed)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetCurrentSessionData(sender: UIButton) {
        
        let alertController = UIAlertController(title: "WARNING - Delete Current Session Data", message: "You are about to delete the data for the current session and start fresh for that session.  If you are signed into iCloud this will delete the data there as well.", preferredStyle: .Alert)
        
        let proceed = UIAlertAction(title: "Proceed", style: .Default, handler: {
            action in
            
            // DELETE current session from entity - Workout
            var request = NSFetchRequest( entityName: "Workout")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]

            let filter = NSPredicate(format: "session == %@",
                self.session)
            
            request.predicate = filter

            do {
                if let workoutObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Workout] {
                    
                    print("workoutObjects.count = \(workoutObjects.count)")
                    
                    for object in workoutObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }

            
            // DELETE current session from entity - WorkoutCompleteDate
            request = NSFetchRequest(entityName: "WorkoutCompleteDate")
            
            do {
                if let workoutCompleteDateObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [WorkoutCompleteDate] {
                    
                    print("workoutCompleteDateObjects.count = \(workoutCompleteDateObjects.count)")
                    
                    for object in workoutCompleteDateObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // DELETE current session from entity - Photo
            request = NSFetchRequest(entityName: "Photo")
            
            do {
                if let photoObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Photo] {
                    
                    print("photoObjects.count = \(photoObjects.count)")
                    
                    for object in photoObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // DELETE current session from entity - Measurement
            request = NSFetchRequest(entityName: "Measurement")
            
            do {
                if let measurementObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Measurement] {
                    
                    print("measurementObjects.count = \(measurementObjects.count)")
                    
                    for object in measurementObjects {
                        
                        // Delete duplicate records.
                        CDHelper.shared.context.deleteObject(object)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
            
            // Save data to database
            CDHelper.saveSharedContext()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(proceed)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func findEmailSetting() {
        
        // Fetch defaultEmail data.
        let request = NSFetchRequest( entityName: "Email")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
        
                print("emailObjects.count = \(emailObjects.count)")
                
                if emailObjects.count != 0 {
                    
                    // There is a default email address.
                    self.emailDetail.text = emailObjects.last?.defaultEmail
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    func findRoutineSetting() {
        
        let routine = CDOperation.getCurrentRoutine()
        
        for i in 0..<2 {
            
            if self.defaultRoutine.titleForSegmentAtIndex(i) == routine {
                
                self.defaultRoutine.selectedSegmentIndex = i
            }
        }
    }
    
    func findUseAutoLockSetting() {
        
        // Fetch defaultEmail data.
        let request = NSFetchRequest( entityName: "AutoLock")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let autoLockObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [AutoLock] {
                
                print("autoLockObjects.count = \(autoLockObjects.count)")
                
                if autoLockObjects.count != 0 {
                    
                    // Match Found
                    if autoLockObjects.last?.useAutoLock == "ON" {
                        
                        self.autoLockSwitch.setOn(true, animated: true)
                    }
                    else {
                        
                        self.autoLockSwitch.setOn(false, animated: true)
                    }
                }
                else {
                    
                    // No Matches Found
                    self.autoLockSwitch.setOn(false, animated: true)
                }
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    func sendEmail(sessionType: String, cvsString: String) {
        
        // Create MailComposerViewController object.
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.navigationBar.tintColor = UIColor.whiteColor()
        
        // Check to see if the device has at least 1 email account configured
        if MFMailComposeViewController.canSendMail() {
            
            let csvData = cvsString.dataUsingEncoding(NSASCIIStringEncoding)
            var fileName = ""
            var subject = ""
            
            switch sessionType {
            case "All":
                fileName = "AllSessionsData.csv"
                subject = "90 DWT BB All Sessions Workout Data"
                
            default:
                // "Current"
                fileName = "Session\(self.session)Data.csv"
                subject = "90 DWT BB Session \(self.session) Workout Data"
            }
            
            
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
            mailcomposer.setSubject(subject)
            mailcomposer.addAttachmentData(csvData!, mimeType: "text/csv", fileName: fileName)
            
            presentViewController(mailcomposer, animated: true, completion: {
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
