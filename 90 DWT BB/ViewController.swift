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
    //var headerView:UIView
    lazy var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.adView.delegate = self
        self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                       MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
        
        //let newView = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        //self.headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 0))
        self.headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 0))
        
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

