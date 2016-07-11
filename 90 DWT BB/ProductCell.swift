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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
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
            
            titleLabel.text = product.localizedTitle
            priceLabel.text = ProductCell.priceFormatter.stringFromNumber(product.price)
            descriptionLabel.text = product.localizedDescription

            if Products.store.isProductPurchased(product.productIdentifier) {
                
                // The product was purchased so show the checkmark.
                buyButton.setTitle("", forState: UIControlState.Normal)
                buyButton.setImage(UIImage(named: "RED_White_CheckMark"), forState: UIControlState.Normal)
                buyButton.userInteractionEnabled = false
                
            } else if IAPHelper.canMakePayments() {
                
                // The product has not been purchased.
                // The customer is allowed to purchase it.
                buyButton.hidden = false
                buyButton.userInteractionEnabled = true
                
            } else {
                
                // The customer is not allowed to purchase it.
                buyButton.hidden = true
                priceLabel.text = "Not Available"
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
    
    @IBAction func buyButtonPressedDown(sender: UIButton) {
        
        // Set the default alpha state for the animation.
        buyButton.titleLabel?.alpha = 0.15
    }
    
    @IBAction func buyButtonTapped(sender: UIButton) {
        
        // User released the buy button so start the ainimation back to full alpha.
        UIView.animateWithDuration(0.3, animations: {
            
            self.buyButton.titleLabel?.alpha = 1.0
        })
        
        buyButtonHandler?(product: product!)
    }

//    func newBuyButton() -> UIButton {
//        let button = UIButton(type: .System)
//        button.setTitleColor(tintColor, forState: .Normal)
//        button.setTitle("Buy", forState: .Normal)
//        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
//        button.sizeToFit()
//        
//        return button
//    }
}