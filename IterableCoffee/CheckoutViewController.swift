//
//  CheckoutViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/25/21.
//

import UIKit
import Foundation
import IterableSDK

class CheckoutViewController: UIViewController {

    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var backToMenuBtn: UIButton!
    var total: Float = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the button press effect here
        setupButtonEffects()
    }
       
    // MARK: Make a Purchase
    @IBAction func completePurchase(_ sender: UIButton) {
        //Calculate the total in the cart
        for item in MyCart.cart {
            total += Float(truncating: item.price)
        }
        
        // Create datafields for the purchase.  Since this is a Coffee App, assume we need the Store Address where the customer can pick up their drink order
        var dataFields: [String: Any] = [
                   "Store_Address": [
                       "Street1": "123 Main St",
                       "Street2": "Apt 1",
                       "City": "Iter-a-ville",
                       "State": "CA",
                       "Zip": "90210"
                   ]
               ]
        // MARK: Attribution - Track this Purchase against a Campaign
        //Obtain the most recent Attribution Info
        let attributionInfo = IterableAPI.attributionInfo
        //If there is Attribution Info, add it to the dataFields for the purchase
        if let attributionInfo = attributionInfo {
                    dataFields["campaignId"] = attributionInfo.campaignId
                    dataFields["templateId"] = attributionInfo.templateId
                    dataFields["messageId"] = attributionInfo.messageId
                }
       
        //Track a Purchase Event
        IterableAPI.track(purchase: NSNumber(value: total), items: MyCart.cart, dataFields: dataFields)
        
        //Empty the App's Cart
        MyCart.cart.removeAll()
        
    }
    // MARK: Button Effects
    func setupButtonEffects() {
        purchaseBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        purchaseBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        backToMenuBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        backToMenuBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    // Button press effect: Scale down when pressed
    @objc func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    // Button press effect: Scale back to normal when released
    @objc func buttonTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
