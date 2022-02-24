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
        initializeHideKeyboard()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var emailCaptured: String = "nam.ngo+ios5@iterable.com"
    var pwCaptured: String = "demo"
    
    @IBAction func loginCompletedTest(_ sender: UIButton) {
        emailCaptured = emailField.text?.lowercased() ?? "nam.ngo+ios5@iterable.com"
        pwCaptured = passwordField.text ?? "demo"
        
        if (emailCaptured.isEmpty) {
            emailCaptured = "nam.ngo+ios5@iterable.com"
        }
        if pwCaptured.isEmpty {
            pwCaptured = "demo"
        }
        
        print("Login Successful")
        print(emailCaptured)
        IterableAPI.email = emailCaptured
        IterableAPI.track(
            event: "login successful"
        )
        
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
   
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
    
}

