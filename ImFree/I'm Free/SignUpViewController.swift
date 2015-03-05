//
//  SignUpViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 3/2/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

   @IBOutlet weak var firstNameTextField: UITextField!
   @IBOutlet weak var lastNameTextField: UITextField!
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   
   @IBOutlet weak var registerSpinner: UIActivityIndicatorView!
   @IBOutlet weak var registerButton: UIButton!
   
   
   @IBAction func checkSignUp(sender: UIButton) {
      let firstName = firstNameTextField.text
      let lastName = lastNameTextField.text
      let email = emailTextField.text
      let password = passwordTextField.text
      
      if firstName.isEmpty {
         makeAlert("Error", Message: "You must fill in a first name")
         return
      }
      if lastName.isEmpty {
         makeAlert("Error", Message: "You must fill in a last name")
         return
      }
      if email.isEmpty {
         makeAlert("Error", Message: "You must fill in an email")
         return
      }
      if password.isEmpty {
         makeAlert("Error", Message: "You must fill in a password")
         return
      }
      
      busy()
      
      let newUser = PFUser()
      newUser.username = email
      newUser.email = email
      newUser.password = password
      newUser.setValue(firstName, forKey: "FirstName")
      newUser.setValue(lastName, forKey: "LastName")
      
      newUser.signUpInBackgroundWithBlock {
         (succeeded: Bool!, error: NSError!) -> Void in
         if error == nil {
            PersistanceUtils.write(email, forKey: "username")
            PersistanceUtils.write(password, forKey: "password")
            self.performSegueWithIdentifier("signedUpSegue", sender: self)
         } else {
            let errorString = error.userInfo?["error"] as NSString
            self.makeAlert("ERROR", Message: errorString)
            self.notBusy()
         }
      }
   }
   
   func makeAlert(title: String, Message message: String) {
      var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
   }
   
   
   func busy() {
      registerSpinner.hidden = false
      registerButton.hidden = true
   }
   
   func notBusy() {
      registerSpinner.hidden = true
      registerButton.hidden = false
   }
   
   
    override func viewDidLoad() {
        super.viewDidLoad()

        notBusy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
