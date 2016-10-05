//
//  MeasurementNavigationController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 10/4/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class MeasurementNavigationController: UINavigationController {

    override func viewWillAppear(animated: Bool) {
        
        let parentTBC = self.tabBarController as! MainTBC
        
        if parentTBC.sessionChangedForMeasurementNC {
            
            parentTBC.sessionChangedForMeasurementNC = false
            self.popToRootViewControllerAnimated(true)
        }
    }
}
