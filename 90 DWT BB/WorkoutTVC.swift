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
        
        exerciseNameArray = [["ProgressiveCell"],
                             ["ProgressiveCell", "ProgressiveCell"],
                             ["ProgressiveCell", "ProgressiveCell", "ProgressiveCell"],
                             ["ProgressiveCell"],
                             ["ProgressiveCell", "ProgressiveCell"],
                             ["ForceCell", "ForceCell"]]
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
        
        let cellIdentifier = exerciseNameArray[indexPath.section][indexPath.row]
        
        if cellIdentifier as! String == "ForceCell" {
            
            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as! WorkoutTVC_TableViewCell
        }
        else {
            
            return tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as! LargerCell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Set \(section + 1) of \(numberOfSectionsInTableView(tableView))"
    }
    
    

    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Set the color of the header/footer text
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.whiteColor()
        
        // Set the background color of the header/footer
        header.contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
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
