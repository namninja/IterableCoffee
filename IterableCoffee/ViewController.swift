//
//  ViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import IterableSDK
import IterableAppExtensions
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class ViewController: UIViewController {

    
    let user = TestData.testData
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    var emailCaptured: String = ""
    var pwCaptured: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        // Add the button press effect here
        setupButtonEffects()
    }
    
    // MARK: Login User
    //You can skip entering in custom values by clicking the Login button.  This will use the default user values in User.swift
    //You can also enter custom values into the form and replace the default values
    
    @IBAction func loginCompletedTest(_ sender: UIButton) {
        print("++++++++", user.email)
        // Check for nil or empty string for emailField
            if let emailText = emailField.text, !emailText.isEmpty {
                emailCaptured = emailText.lowercased()
            } else {
                emailCaptured = user.email
            }
            
            // Check for nil or empty string for passwordField
            if let passwordText = passwordField.text, !passwordText.isEmpty {
                pwCaptured = passwordText
            } else {
                pwCaptured = user.password
            }

        print("Login Successful")
        print("++++++++", emailCaptured)
        
        //Identify the User and cache email (can also use userId) to be used in subsequent SDK Method calls.
        IterableAPI.setEmail(emailCaptured)
        
        //track a custom event
        let dataFields = [
            "isLoggedIn": true,
            "favoriteBand": "Radiohead"
        ] as [String : Any]
        
        IterableAPI.track(
            event: "login successful",
            dataFields: dataFields
        )
    }
    
    // MARK: Button Effects
    func setupButtonEffects() {
        loginButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        signupButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        signupButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
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
    
    // MARK: - Utility - Remove Keyboard
    // Removes Keyboard when clicking done or tapping outside of it
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

