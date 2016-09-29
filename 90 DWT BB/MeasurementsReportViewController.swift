//
//  MeasurementsReportViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 8/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData
import Social

class MeasurementsReportViewController: UIViewController, MFMailComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet weak var htmlView: UIWebView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var session = ""
    var month1Array = NSMutableArray()
    var month2Array = NSMutableArray()
    var month3Array = NSMutableArray()
    var finalArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMeasurements()
        self.htmlView.loadHTMLString(self.createHTML() as String, baseURL: nil)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Share", message: "", preferredStyle: .ActionSheet)
        
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: {
            action in
            
            self.emailSummary()
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
    
    func emailSummary() {
        
        // Create MailComposerViewController object.
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.navigationBar.tintColor = UIColor.whiteColor()
        
        let writeString = NSMutableString()
        
        // Check to see if the device has at least 1 email account configured
        if MFMailComposeViewController.canSendMail() {
            
            // Create an array of measurements to iterate thru when building the table rows.
            let measurementsArray = [self.month1Array, self.month2Array, self.month3Array, self.finalArray]
            let measurementsMonth = ["Start Month 1", "Start Month 2", "Start Month 3", "Final"]
            
            writeString.appendString("Session,Month,Weight,Chest,Left Arm,Right Arm,Waist,Hips,Left Thigh,Right Thigh\n")
            
            for i in 0..<measurementsMonth.count {
                
                writeString.appendFormat("%@,%@", self.session, measurementsMonth[i])
                
                for j in 0..<self.month1Array.count {
                    
                    writeString.appendFormat(",%@", measurementsArray[i][j] as! String)
                }
                
                writeString.appendString("\n")
            }
        }
        
        // Send email
        
        let csvData = writeString.dataUsingEncoding(NSASCIIStringEncoding)
        let subject = NSString .localizedStringWithFormat("90 DWT BB %@ Measurements - Session %@", self.navigationItem.title!, session)
        let fileName = NSString .localizedStringWithFormat("90 DWT BB %@ Measurements - Session %@.csv", self.navigationItem.title!, session)
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loadMeasurements() {
        
        let monthArray = ["1",
                          "2",
                          "3",
                          "4"]
        
        // Get workout data with the current session
        let request = NSFetchRequest( entityName: "Measurement")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        for i in 0..<monthArray.count {
            
            let filter = NSPredicate(format: "session == %@ AND month == %@",
                                     session,
                                     monthArray[i])
            
            request.predicate = filter

            do {
                if let measurementObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Measurement] {
                    
                    print("measurementObjects.count = \(measurementObjects.count)")
                    
                    if measurementObjects.count >= 1 {
                        
                        if monthArray[i] == "1" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" || measurementObjects.last?.weight == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" || measurementObjects.last?.chest == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" || measurementObjects.last?.leftArm == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" || measurementObjects.last?.rightArm == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" || measurementObjects.last?.waist == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" || measurementObjects.last?.hips == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" || measurementObjects.last?.leftThigh == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" || measurementObjects.last?.rightThigh == nil {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }
                        
                        else if monthArray[i] == "2" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" || measurementObjects.last?.weight == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" || measurementObjects.last?.chest == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" || measurementObjects.last?.leftArm == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" || measurementObjects.last?.rightArm == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" || measurementObjects.last?.waist == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" || measurementObjects.last?.hips == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" || measurementObjects.last?.leftThigh == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" || measurementObjects.last?.rightThigh == nil {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }

                        else if monthArray[i] == "3" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" || measurementObjects.last?.weight == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" || measurementObjects.last?.chest == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" || measurementObjects.last?.leftArm == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" || measurementObjects.last?.rightArm == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" || measurementObjects.last?.waist == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" || measurementObjects.last?.hips == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" || measurementObjects.last?.leftThigh == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" || measurementObjects.last?.rightThigh == nil {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }

                        else if monthArray[i] == "4" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" || measurementObjects.last?.weight == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" || measurementObjects.last?.chest == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" || measurementObjects.last?.leftArm == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" || measurementObjects.last?.rightArm == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" || measurementObjects.last?.waist == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" || measurementObjects.last?.hips == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" || measurementObjects.last?.leftThigh == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" || measurementObjects.last?.rightThigh == nil {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }
                    }
                    
                    else {
                        
                        if monthArray[i] == "1" {
                            
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                            self.month1Array.addObject("0")
                        }
                        
                        else if monthArray[i] == "2" {
                            
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                            self.month2Array.addObject("0")
                        }
                        
                        else if monthArray[i] == "3" {
                            
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                            self.month3Array.addObject("0")
                        }
                        
                        else if monthArray[i] == "4" {
                            
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                            self.finalArray.addObject("0")
                        }
                    }
                }
                
            } catch { print(" ERROR executing a fetch request: \( error)") }
        }
    }
    
    func createHTML() -> NSString {
        
        // Create an array of measurements to iterate thru when building the table rows.
        let measurementsArray = [self.month1Array, self.month2Array, self.month3Array, self.finalArray]
        let measurementsNameArray = ["Weight", "Chest", "Left Arm", "Right Arm", "Waist", "Hips", "Left Thigh", "Right Thigh"]
        
        var myHTML = "<html><head>"
        
        // Table Style
        myHTML = myHTML.stringByAppendingFormat("<STYLE TYPE='text/css'><!--TD{font-family: Arial; font-size: 12pt;}TH{font-family: Arial; font-size: 14pt;}---></STYLE></head><body><table border='1' bordercolor='#3399FF' style='background-color:#CCCCCC' width='%f' cellpadding='2' cellspacing='1'>", self.htmlView.frame.size.width - 15)
        
        // Table Headers
        myHTML = myHTML.stringByAppendingFormat("<tr><th style='background-color:#999999'>Session %@</th><th style='background-color:#999999'>1</th><th style='background-color:#999999'>2</th><th style='background-color:#999999'>3</th><th style='background-color:#999999'>Final</th></tr>", session)
        
        // Table Data
        for i in 0..<measurementsNameArray.count {
            
            myHTML = myHTML.stringByAppendingFormat("<tr><td style='background-color:#999999'>%@</td>", measurementsNameArray[i])
            
            for a in 0..<measurementsArray.count {
                
                myHTML = myHTML.stringByAppendingFormat("<td>%@</td>", measurementsArray[a][i] as! String)
            }
            
            myHTML = myHTML.stringByAppendingString("</tr>")
        }
        
        // HTML closing tags
        myHTML = myHTML.stringByAppendingString("</table></body></html>")
        
        return myHTML
    }
}
