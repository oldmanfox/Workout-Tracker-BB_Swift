/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    static let priceFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        
        formatter.formatterBehavior = .Behavior10_4
        formatter.numberStyle = .CurrencyStyle
        
        return formatter
    }()
    
    var buyButtonHandler: ((product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            ProductCell.priceFormatter.locale = product.priceLocale
            
            let titleName:String? = product.localizedTitle
            let titlePrice:String? = ProductCell.priceFormatter.stringFromNumber(product.price)
            textLabel?.text = "\(titleName!) - \(titlePrice!)"
            
            detailTextLabel?.text = product.localizedDescription
            
            //textLabel?.text = product.localizedTitle
            
            if Products.store.isProductPurchased(product.productIdentifier) {
                //accessoryType = .Checkmark
                let accessoryCheckMark = UIImage(named: "Orange-White-Check")
                let accessoryViewForCell = UIImageView(image: accessoryCheckMark)
                
                
                
                accessoryType = .None
                accessoryView = accessoryViewForCell
                //detailTextLabel?.text = ""
            } else if IAPHelper.canMakePayments() {
                //ProductCell.priceFormatter.locale = product.priceLocale
                //detailTextLabel?.text = ProductCell.priceFormatter.stringFromNumber(product.price)
                
                accessoryType = .None
                accessoryView = self.newBuyButton()
            } else {
                textLabel?.text = "\(titleName!) - Not Available"
                
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .System)
        button.setTitleColor(tintColor, forState: .Normal)
        button.setTitle("Buy", forState: .Normal)
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    func buyButtonTapped(sender: AnyObject) {
        buyButtonHandler?(product: product!)
    }
}