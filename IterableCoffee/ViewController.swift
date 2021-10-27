//
//  ViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import IterableSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginCompletedTest(_ sender: UIButton) {
        print("Login Successful")
        IterableAPI.email = "nam.ngo+iosapp3@iterable.com"
        IterableAPI.track(
            event: "login successful"
        )
    }
    @IBAction func newUserTest(_ sender: UIButton) {
        print("New User Created Successful")
        
        IterableAPI.email = "nam.ngo+iosapp3@iterable.com"
        IterableAPI.updateUser([
            "firstName": "David",
            "lastName" : "Bowie",
            "age" : 45,
            "favoriteCafeBeverage": "latte",
            "phoneNumber": "+18582294679"
        ], mergeNestedObjects: false)
                               
            IterableAPI.track(
            event: "signup complete",
            dataFields: [
                "firstName": "David",
                "lastName" : "Bowie",
                "age" : 45,
                "favoriteCafeBeverage": "latte",
                "phoneNumber": "+18582294679"
                        ]
        )
    }
}

