//
//  WorkoutNavigationController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 10/3/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutNavigationController: UINavigationController {
    
    override func viewWillAppear(animated: Bool) {
        
        let parentTBC = self.tabBarController as! MainTBC
        
        if parentTBC.routineChangedForWorkoutNC || parentTBC.sessionChangedForWorkoutNC {
            
            if parentTBC.routineChangedForWorkoutNC {
                
                parentTBC.routineChangedForWorkoutNC = false
            }
            
            if parentTBC.sessionChangedForWorkoutNC {
                
                parentTBC.sessionChangedForWorkoutNC = false
            }
            
            self.popToRootViewControllerAnimated(true)
        }
    }
        
//        - (void)viewWillAppear:(BOOL)animated
//    {
//    if (((MainTBC *)self.parentViewController).workoutChanged) {
//    
//    [self popToRootViewControllerAnimated:YES];
//    ((MainTBC *)self.parentViewController).workoutChanged = NO;
//    }
//    
//    if ([[_0DWTHCIAPHelper sharedInstance] productPurchased:@"com.grantdevelopers.60DWTHC.removeads"]) {
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (appDelegate.purchasedAdRemoveBeforeAppLaunch) {
//    
//    // Do nothing.  No need to pop to root view controller.
//    
//    } else {
//    
//    [self popToRootViewControllerAnimated:YES];
//    }
//    }
//    }

}
