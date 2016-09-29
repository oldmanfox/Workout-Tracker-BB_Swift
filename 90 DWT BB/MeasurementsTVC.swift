//
//  MeasurementsTVC.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 8/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class MeasurementsTVC: UITableViewController {
    
    let cellTitles = [["Start Month 1", "Start Month 2", "Start Month 3", "Final"],
                      ["All"]]
    
    var session = ""
    var monthString = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get the current session
        session = CDOperation.getCurrentSession()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 4
        }
        else {
            
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = cellTitles[indexPath.section][indexPath.row]
        
        if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "next_arrow")) {
            
            cell.accessoryView = tempAccessoryView
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "Record Your Measurements"
        }
        else {
            
            return "View Your Measurements"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            // Section = 0
            switch indexPath.row {
            case 0:
                monthString = "1"
                
            case 1:
                monthString = "2"
                
            case 2:
                monthString = "3"
            
            default:
                monthString = "4"
            }
            
            self.performSegueWithIdentifier("toRecordMeasurements", sender: indexPath)
            
        default:
            // Section = 1
            self.performSegueWithIdentifier("toViewMeasurements", sender: indexPath)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toRecordMeasurements" {
            
            let destinationVC = segue.destinationViewController as? MeasurementsRecordViewController
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = cellTitles[(selectedRow?.section)!][(selectedRow?.row)!]
            destinationVC?.session = self.session
            destinationVC?.monthString = self.monthString
        }
        else {
            // MeasurementsReportViewController
            
            let destinationVC = segue.destinationViewController as? MeasurementsReportViewController
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.navigationItem.title = cellTitles[(selectedRow?.section)!][(selectedRow?.row)!]
            destinationVC?.session = self.session
        }
    }

    
    
}
