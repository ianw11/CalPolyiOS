//
//  LoginViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/24/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

   @IBOutlet weak var usernameTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   
   @IBOutlet weak var savePasswordSwitch: UISwitch!
   
   @IBOutlet weak var loginButton: UIButton!
   @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
   
   @IBAction func doLogin(sender: UIButton) {
      let username = usernameTextField.text
      let password = passwordTextField.text
      
      if (username != "" && password != "") {
         loginButton.hidden = true
         loginSpinner.hidden = false
         
         if savePasswordSwitch.on {
            PersistanceUtils.write(username, forKey: "username")
            PersistanceUtils.write(password, forKey: "password")
         } else {
            PersistanceUtils.clear("username")
            PersistanceUtils.clear("password")
         }
         
         myLogin(username, Password: password)
      }
      
   }
   
   func myLogin(username: String, Password password: String) {
      PFUser.logInWithUsernameInBackground(username, password: password) {
         (user: PFUser!, error: NSError!) -> Void in
         if user != nil {
            // Do stuff after successful login.
            self.successfulLogin()
         } else {
            // The login failed. Check error to see why.
            let errorString = error.userInfo?["error"] as NSString
            self.failedLogin(errorString)
            PersistanceUtils.dropCredentials()
         }
      }
   }
   
   
   func successfulLogin() {
      self.performSegueWithIdentifier("loginSegue", sender: self)
   }
   
   func failedLogin(message: String) {
      
      loginButton.hidden = false
      loginSpinner.hidden = true
      
      var alert = UIAlertController(title: "Attention", message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
   }
   
   
   @IBAction func segueToSignup(sender: UIButton) {
      self.performSegueWithIdentifier("signupSegue", sender: self)
   }
   
   
   @IBAction func forgotPassword(sender: UIButton) {
      
      let alert = UIAlertController(title: "Forgot Password?", message: "Enter email", preferredStyle: UIAlertControllerStyle.Alert)
      
      
      let action = UIAlertAction(title: "Reset My Password!", style: UIAlertActionStyle.Default, handler: { (something: UIAlertAction!) -> Void in
            if let tField = alert.textFields?.first as? UITextField {
               if !tField.text.isEmpty {
                  PFUser.requestPasswordResetForEmail(tField.text)
               }
            }
         }
      )
      alert.addAction(action)
      
      
      let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
         //Just dismiss the action sheet
      }
      alert.addAction(cancelAction)
      
      
      alert.addTextFieldWithConfigurationHandler { textField -> Void in
         //TextField configuration
         textField.textColor = UIColor.blueColor()
      }
      
      
      
      self.presentViewController(alert, animated: true) { () -> Void in
         // nothing
      }
      
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      loginButton.hidden = true
      loginSpinner.hidden = false
      
      // Do any additional setup after loading the view.
      
      let username: String? = PersistanceUtils.read("username") as String?
      
      if let username = username? {
         if username != "" {
            let password: String = PersistanceUtils.read("password") as String
            myLogin(username, Password: password)
         }
      }
      
      loginButton.hidden = false
      loginSpinner.hidden = true
      
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
