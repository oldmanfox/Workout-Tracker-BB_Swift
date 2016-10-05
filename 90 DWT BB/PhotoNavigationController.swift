//
//  PhotoNavigationController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 10/4/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class PhotoNavigationController: UINavigationController {

    override func viewWillAppear(animated: Bool) {
        
        let parentTBC = self.tabBarController as! MainTBC
        
        if parentTBC.sessionChangedForPhotoNC {
            
            parentTBC.sessionChangedForPhotoNC = false
            self.popToRootViewControllerAnimated(true)
        }
    }
}
