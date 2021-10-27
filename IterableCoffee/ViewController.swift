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

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var emailCaptured: String = ""
    var pwCaptured: String = ""
    
    @IBAction func loginCompletedTest(_ sender: UIButton) {
        emailCaptured = emailField.text?.lowercased() ?? "nam.ngo+iosapp3@iterable.com"
        pwCaptured = passwordField.text ?? "demo"
        
        print("Login Successful")
        IterableAPI.email = emailCaptured
        IterableAPI.track(
            event: "login successful"
        )
    }
    
}

