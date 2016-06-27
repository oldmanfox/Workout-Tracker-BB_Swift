//
//  MonthTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class MonthTVC: UITableViewController {
    
    var sectionsArray = [[], []]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //navigationItem.title = "Bulk"
        navigationItem.title = "Tone"
        
        findWeekList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sectionsArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sectionsArray[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = sectionsArray[indexPath.section][indexPath.row] as? String
        
        
        
        if let tempAccessoryView:UIImageView = UIImageView (image: UIImage (named: "next_arrow")) {
            
            cell.accessoryView = tempAccessoryView
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 20
        }
        else {
            return 10
        }
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toWeekWorkoutList" {
            
            let destinationVC = segue.destinationViewController as? WeekTVC
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.workoutRoutine = navigationItem.title!
            destinationVC?.workoutWeek = (sectionsArray[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
        }
    }
    
    func findWeekList() {
        
        switch navigationItem.title! {
        case "Bulk":
            sectionsArray = [["Week 1", "Week 2", "Week 3"],
                             ["Week 4", "Week 5", "Week 6", "Week 7", "Week 8", "Week 9"],
                             ["Week 10", "Week 11", "Week 12"]]
            
        case "Tone":
            sectionsArray = [["Week 1", "Week 2", "Week 3"],
                             ["Week 4", "Week 5", "Week 6", "Week 7", "Week 8"],
                             ["Week 9", "Week 10", "Week 11", "Week 12"]]
            
        default:
            sectionsArray = [[], []]
        }
    }
}
