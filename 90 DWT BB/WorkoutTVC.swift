//
//  WorkoutTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutTVC: UITableViewController {

    var exerciseNameArray = [[], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadExerciseNameArray()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 392.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadExerciseNameArray() {
        
        exerciseNameArray = [["6 Progressive Set"],
                             ["6 Progressive Set", "6 Progressive Set"],
                             ["6 Progressive Set", "6 Progressive Set", "6 Progressive Set"],
                             ["6 Progressive Set"],
                             ["6 Progressive Set", "6 Progressive Set"],
                             ["5 Force Set", "5 Force Set"]]
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return exerciseNameArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return exerciseNameArray[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cellIdentifier = ""
//        
//        switch indexPath.row {
//        case 0:
//            cellIdentifier = "5 Force Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 1:
//            cellIdentifier = "6 Progressive Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 2:
//            cellIdentifier = "4 Drop Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 3:
//            cellIdentifier = "5 Force Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 4:
//            cellIdentifier = "6 Progressive Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 5:
//            cellIdentifier = "4 Drop Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 6:
//            cellIdentifier = "5 Force Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        case 7:
//            cellIdentifier = "6 Progressive Set"
//            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
//        default:
//            break
//        }
//        
//        return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
        
//        if indexPath.row == 0 {
//            
//            cellIdentifier = "5 Force Set"
//            
//            
//        }
//        else {
//            
//            cellIdentifier = "6 Progressive Set"
//        }
        
        let cellIdentifier = exerciseNameArray[indexPath.section][indexPath.row]
        
        if cellIdentifier as! String == "5 Force Set" {
            
            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
        }
        else {
            
            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as! LargerCell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: UITableViewDelegate
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        
//        switch indexPath.row {
//        case 0:
//            return 292
//        case 1:
//            return 292
//        case 2:
//            return 292
//        case 3:
//            return 292
//        case 4:
//            return 292
//        case 5:
//            return 292
//        case 6:
//            return 292
//        case 7:
//            return 292
//        default:
//            return 0
//        }
//
//        
////        if indexPath.row == 0 {
////            
////            return 292
////        }
////        else {
////            
////            return 392
////        }
//        
////        if isLandscapeOrientation() {
////            return hasImageAtIndexPath(indexPath) ? 140.0 : 120.0
////        } else {
////            return hasImageAtIndexPath(indexPath) ? 235.0 : 155.0
////        }
//    }
    
//    func isLandscapeOrientation() -> Bool {
//        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
