//
//  SignupViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/27/21.
//

import UIKit
import IterableSDK

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var beverageField: UITextField!
    
    var emailCaptured: String = "nam.ngo+ios6@iterable.com"
    var pwCaptured: String = "demo"
    var firstNameCaptured: String = "Steve"
    var lastNameCaptured: String = "Rogers"
    var phoneCaptured: String = "+18582294679"
    var beverageCaptured: String = "latte"
    
    @IBAction func signUpSubmit(_ sender: UIButton) {
        emailCaptured = emailField.text?.lowercased() ?? "nam.ngo+ios6@iterable.com"
        pwCaptured = passwordField.text ?? "demo"
        firstNameCaptured = firstNameField.text ?? "Steve"
        lastNameCaptured = lastNameField.text ?? "Rogers"
        phoneCaptured = phoneField.text ?? "+18582294679"
        beverageCaptured = beverageField.text?.lowercased() ?? "latte"
        
        if (emailCaptured.isEmpty) {
            emailCaptured = "nam.ngo+ios6@iterable.com"
        }
        if (pwCaptured.isEmpty) {
            pwCaptured = "demo"
        }
        if (firstNameCaptured.isEmpty) {
            firstNameCaptured = "Steve"
        }
        if (lastNameCaptured.isEmpty) {
            lastNameCaptured = "Rogers"
        }
        if (phoneCaptured.isEmpty) {
            phoneCaptured = "+18582294679"
        }
        if (beverageCaptured.isEmpty) {
            beverageCaptured = "latte"
        }
        
        let dataFields = [
            "password": pwCaptured,
            "firstName": firstNameCaptured,
            "lastName" : lastNameCaptured,
            "favoriteCafeBeverage": beverageCaptured,
            "phoneNumber": phoneCaptured
        ]
        print("New User Created Successful")
        print(dataFields)
        IterableAPI.email = emailCaptured
        IterableAPI.updateUser(dataFields, mergeNestedObjects: false)
                               
            IterableAPI.track(
            event: "signup complete",
            dataFields: dataFields
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
     
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
