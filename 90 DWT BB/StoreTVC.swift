//
//  StoreTVC.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 6/23/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class StoreTVC: UITableViewController {
    
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Store"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(StoreTVC.reload), forControlEvents: .ValueChanged)
        
        let restoreButton = UIBarButtonItem(title: "Restore", style: .Plain, target: self, action: #selector(StoreTVC.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StoreTVC.handlePurchaseNotification(_:)),
                                                         name: IAPHelper.IAPHelperPurchaseNotification,
                                                         object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        products = []
        
        //tableView.reloadData()
        
        Products.store.requestProducts{success, products in
            if success {
                self.products = products!
                
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    func restoreTapped(sender: AnyObject) {
        Products.store.restorePurchases()
    }
    
    func handlePurchaseNotification(notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerate() {
            guard product.productIdentifier == productID else { continue }
            
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        }
    }
}

// MARK: - UITableViewDataSource

extension StoreTVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        
        cell.product = product
        cell.buyButtonHandler = { product in
            Products.store.buyProduct(product)
        }
        
        return cell
    }
}

