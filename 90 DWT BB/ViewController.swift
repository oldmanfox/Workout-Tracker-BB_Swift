//
//  ViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 6/22/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MPAdViewDelegate {

    var adView = MPAdView(adUnitId: "AD_UNIT_ID", size: MOPUB_BANNER_SIZE)
    var headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.adView.delegate = self
        self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                       MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
        
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //self.headerView
    }

    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
//    func adViewDidLoadAd(view: MPAdView!) {
//        <#code#>
//    }
//    
//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        <#code#>
//    }
//    
//    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        <#code#>
//    }
}

