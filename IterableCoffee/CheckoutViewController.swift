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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var total: Float = 0.00
    
   

    @IBAction func completePurchase(_ sender: UIButton) {
       
        for item in MyCart.cart {
            total += Float(truncating: item.price)
        }
      

        let dataFields: [String: Any] = [
                   "Store_Address": [
                       "Street1": "123 Main St",
                       "Street2": "Apt 1",
                       "City": "Iter-a-ville",
                       "State": "CA",
                       "Zip": "90210"
                   ]
               ]
       
       
               // Create an array of CommerceItem objects
               
       
               // Make the call to Iterable's API
        IterableAPI.track(purchase: NSNumber(value: total), items: MyCart.cart, dataFields: dataFields)
        MyCart.cart.removeAll()
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
