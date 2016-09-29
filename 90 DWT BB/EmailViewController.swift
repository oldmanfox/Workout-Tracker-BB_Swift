//
//  EmailViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 9/21/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData

class EmailViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var defaultEmail: UITextField!
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        
        self.defaultEmail.resignFirstResponder()
    }
    
    @IBAction func saveEmail(sender: UIBarButtonItem) {
        
        // Fetch defaultEmail data.
        let request = NSFetchRequest( entityName: "Email")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        do {
            if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                
                print("emailObjects.count = \(emailObjects.count)")
                
                switch emailObjects.count {
                case 0:
                    
                    // No Matches.  Create new record and save.
                    let insertEmailInfo = NSEntityDescription.insertNewObjectForEntityForName("Email", inManagedObjectContext: CDHelper.shared.context) as! Email
                    
                    insertEmailInfo.defaultEmail = self.defaultEmail.text
                    insertEmailInfo.date = NSDate()
                    
                default:
                    
                    // There is a default email address.
                    emailObjects.last?.defaultEmail = self.defaultEmail.text
                }
                
                CDHelper.saveSharedContext()
                self.defaultEmail.placeholder = self.defaultEmail.text
                self.defaultEmail.text = ""
            }
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
}
