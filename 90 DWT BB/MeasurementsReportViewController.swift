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

class MeasurementsReportViewController: UIViewController {
    
    @IBOutlet weak var htmlView: UIWebView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var session = ""
    var month1Array = NSMutableArray()
    var month2Array = NSMutableArray()
    var month3Array = NSMutableArray()
    var finalArray = NSMutableArray()
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        
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
                            if measurementObjects.last?.weight == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" {
                                self.month1Array.addObject("0")
                            }
                            else {
                                self.month1Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }
                        
                        else if monthArray[i] == "2" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" {
                                self.month2Array.addObject("0")
                            }
                            else {
                                self.month2Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }

                        else if monthArray[i] == "3" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" {
                                self.month3Array.addObject("0")
                            }
                            else {
                                self.month3Array.addObject((measurementObjects.last?.rightThigh)!)
                            }
                        }

                        else if monthArray[i] == "4" {
                            
                            // Weight
                            if measurementObjects.last?.weight == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.weight)!)
                            }
                            
                            // Chest
                            if measurementObjects.last?.chest == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.chest)!)
                            }
                            
                            // Left Arm
                            if measurementObjects.last?.leftArm == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.leftArm)!)
                            }
                            
                            // Right Arm
                            if measurementObjects.last?.rightArm == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.rightArm)!)
                            }
                            
                            // Waist
                            if measurementObjects.last?.waist == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.waist)!)
                            }
                            
                            // Hips
                            if measurementObjects.last?.hips == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.hips)!)
                            }
                            
                            // Left Thigh
                            if measurementObjects.last?.leftThigh == "" {
                                self.finalArray.addObject("0")
                            }
                            else {
                                self.finalArray.addObject((measurementObjects.last?.leftThigh)!)
                            }
                            
                            // Right Thigh
                            if measurementObjects.last?.rightThigh == "" {
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
}
