//
//  FirstViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/19/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
   
   @IBOutlet weak var timePicker: UIDatePicker!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var updateButton: UIButton!
   
   @IBOutlet weak var statusTextField: UILabel!
   
   var frozen = false;
   
   @IBAction func updateLocation(sender: UIButton) {
      
      if frozen {
         unfreeze()
      } else {
         if locationTextField.text.isEmpty {
            self.makeAlert("Error", Message: "You must specify a location")
            return
         }
         let currentUser = PFUser.currentUser()
         
         /* Code to save the user's Lat/Long
            It should be failable */
         PFGeoPoint.geoPointForCurrentLocationInBackground() {
            (point:PFGeoPoint!, error:NSError!) -> Void in
            
            if point != nil {
               println("Lat: \(point.latitude) Lon: \(point.longitude)")
               currentUser.setValue(point, forKey: "Location")
               
               currentUser.saveInBackgroundWithBlock {
                  (success: Bool, error: NSError!) -> Void in
                  if success {
                     println("Successfully saved LOCATION")
                  } else {
                     println("Failed to save location")
                  }
               }
               
            } else {
               // Failed to get location - Point is nil
               NSLog("Failed to get current location")
            }
         }
         
         currentUser.setValue(timePicker.date, forKey: "TimeFree")
         currentUser.setValue(locationTextField.text, forKey: "UserLocation")
         
         currentUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
               println("Successfully saved TIME")
            } else {
               println("Error in saving: \(error.description)")
            }
         }
         
         freeze()
      }
      
   }
   
   func freeze() {
      frozen = true
      
      let location = PFUser.currentUser().valueForKey("UserLocation") as String
      locationTextField.text = location
      locationTextField.enabled = false
      
      timePicker.hidden = true
      statusTextField.hidden = false
      
      let time = PFUser.currentUser().valueForKey("TimeFree") as NSDate
      let formatter = NSDateFormatter()
      formatter.dateFormat = "hh:mm"
      
      statusTextField.text = "FREE UNTIL\n\(formatter.stringFromDate(time))"
      let font = UIFont(name: "Chalkduster", size: CGFloat(30))
      statusTextField.font = font
      
      updateButton.setTitle("Cancel", forState: UIControlState.Normal)
   }
   
   func unfreeze() {
      frozen = false
      
      locationTextField.enabled = true
      locationTextField.text = ""
      
      timePicker.hidden = false
      statusTextField.hidden = true
      
      updateButton.setTitle("I'm Free!", forState: UIControlState.Normal)
   }
   
   
   func makeAlert(title: String, Message message: String) {
      var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      
      var currentUser = PFUser.currentUser()
      if currentUser != nil {
         println("Refreshing (fetching) user")
         currentUser.fetch()
      } else {
         // Show the signup or login screen
         println("ERROR: currentUser is nil!")
      }
      
      let oldTime = currentUser.valueForKey("TimeFree") as NSDate?
      
      if oldTime != nil && oldTime!.timeIntervalSinceNow > 0 {
         freeze()
      } else {
         unfreeze()
      }
      
      /*
      var query = PFQuery(className:"FriendRequests")
      
      var testObject: PFObject = query.getFirstObject()
      let KEY = "OwnedBy"
      println("blah: \(testObject.valueForKey(KEY))")
      
      
      let myObject = query.whereKey("OwnedBy", equalTo: "bm@bm.com").getFirstObject()
      for key in myObject.allKeys() {
         println("\(key): \(myObject[key as String])")
      }
      */
      
      /*
      query.getObjectInBackgroundWithId("OwnedBy") {
         (owner: PFObject!, error: NSError!) -> Void in
         if error == nil {
            println("And accessing the FriendRequests table is a success")
            NSLog("%@", owner)
         } else {
            println("ERROR: Accessing FriendRequests failed")
            NSLog("%@", error)
         }
      }
      */
      
      
   }

   @IBAction func logout(sender: UIBarButtonItem) {
      PFUser.currentUser()
      PFUser.logOut()
      
      PersistanceUtils.dropCredentials()
      
      self.performSegueWithIdentifier("logOut1", sender: self)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      println("Preparing for segue!")
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }


}

