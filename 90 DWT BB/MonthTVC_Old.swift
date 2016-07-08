//
//  MonthTVC.swift
//  90 DWT BB
//
//  Created by Jared Grant on 6/25/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class MonthTVC_Old: CDTableViewController {
    
    var sectionsArray = [[], []]
    
    private struct Week {
        static let week1 = "Week 1"
        static let week2 = "Week 2"
        static let week3 = "Week 3"
        static let week4 = "Week 4"
        static let week5 = "Week 5"
        static let week6 = "Week 6"
        static let week7 = "Week 7"
        static let week8 = "Week 8"
        static let week9 = "Week 9"
        static let week10 = "Week 10"
        static let week11 = "Week 11"
        static let week12 = "Week 12"
    }
    
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Workout"
        self.sort = [NSSortDescriptor(key: "date", ascending: true)]
        //self.sectionNameKeyPath = "locationAtHome.storedIn"
        self.fetchBatchSize = 25
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationItem.title = "Bulk"
        //navigationItem.title = "Tone"
        
        findWeekList()
        
//        performFetch()
        print("VIEWDIDLOAD")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEWDIDAPPEAR")
        performFetch()

//        // Trigger Deduplication
//        CDDeduplicator.deDuplicateEntityWithName("Workout", uniqueAttributeName: "date", backgroundMoc: CDHelper.shared.importContext)
//        
//        CDHelper.saveSharedContext()
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
            
            let destinationVC = segue.destinationViewController as? WeekTVC_Old
            let selectedRow = tableView.indexPathForSelectedRow
            
            destinationVC?.workoutRoutine = navigationItem.title!
            destinationVC?.workoutWeek = (sectionsArray[(selectedRow?.section)!][(selectedRow?.row)!] as? String)!
        }
    }
    
    func findWeekList() {
        
        switch navigationItem.title! {
        case "Bulk":
            sectionsArray = [[Week.week1, Week.week2, Week.week3],
                             [Week.week4, Week.week5, Week.week6, Week.week7, Week.week8, Week.week9],
                             [Week.week10, Week.week11, Week.week12]]
            
        case "Tone":
            sectionsArray = [[Week.week1, Week.week2, Week.week3],
                             [Week.week4, Week.week5, Week.week6, Week.week7, Week.week8],
                             [Week.week9, Week.week10, Week.week11, Week.week12]]
            
        default:
            sectionsArray = [[], []]
        }
    }
}
