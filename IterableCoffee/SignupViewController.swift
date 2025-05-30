//
//  SignupViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/27/21.
//

import UIKit
import IterableSDK

class SignupViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var beverageField: UITextField!
    @IBOutlet weak var signupSubmitBtn: UIButton!
    
    //Call the User class and store test data to Identify the user in the App and create a User in Iterable
    let user = TestData.testData
    var emailCaptured: String = TestData.testData.email
    var pwCaptured: String = TestData.testData.password
    var firstNameCaptured: String = TestData.testData.firstName
    var lastNameCaptured: String = TestData.testData.lastName
    var phoneCaptured: String = TestData.testData.phoneNumber
    var beverageCaptured: String = TestData.testData.favoriteBeverage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        // Add the button press effect here
        setupButtonEffects()
    }
    
    // MARK: Signup User
    //If you fill out the Sign Up Form, the values entered will replace the default test data and will be passed into Iterable
    //You can skip entering in custom values by clicking the Submit button.  This will use the default user values in User.swift
    @IBAction func signUpSubmit(_ sender: UIButton) {
        
        
            if let emailText = emailField.text, !emailText.isEmpty {
                emailCaptured = emailText.lowercased()
            } else {
                emailCaptured = user.email
            }
            
            // Password field
            if let passwordText = passwordField.text, !passwordText.isEmpty {
                pwCaptured = passwordText
            } else {
                pwCaptured = user.password
            }
            
            // First Name field
            if let firstNameText = firstNameField.text, !firstNameText.isEmpty {
                firstNameCaptured = firstNameText
            } else {
                firstNameCaptured = user.firstName
            }
            
            // Last Name field
            if let lastNameText = lastNameField.text, !lastNameText.isEmpty {
                lastNameCaptured = lastNameText
            } else {
                lastNameCaptured = user.lastName
            }
            
            // Phone Number field
            if let phoneText = phoneField.text, !phoneText.isEmpty {
                phoneCaptured = phoneText
            } else {
                phoneCaptured = user.phoneNumber
            }
            
            // Beverage field
            if let beverageText = beverageField.text, !beverageText.isEmpty {
                beverageCaptured = beverageText.lowercased()
            } else {
                beverageCaptured = user.favoriteBeverage
            }
      
        let dataFields = [
            "password": pwCaptured,
            "firstName": firstNameCaptured,
            "lastName" : lastNameCaptured,
            "favoriteCafeBeverage": beverageCaptured,
            "isRegisteredUser": phoneCaptured,
            
        ]

        print("New User Created Successful")
        print(dataFields)
        
        //Identify the User
        IterableAPI.setEmail(emailCaptured)
        
        //Update the User Profile
        IterableAPI.updateUser(dataFields, mergeNestedObjects: false)
        
        //track a custom event
        IterableAPI.track(event: "signup complete", dataFields: dataFields)
        IterableAPI.inAppManager.getInboxMessages()
    }
    // MARK: Button Effects
    func setupButtonEffects() {
        signupSubmitBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        signupSubmitBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
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
     
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
