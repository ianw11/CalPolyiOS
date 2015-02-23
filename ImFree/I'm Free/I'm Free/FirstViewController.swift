//
//  FirstViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/19/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
   
   @IBAction func setLocation1(sender: UIButton) {
      
      println("I pressed a button")
      var currentUser = PFUser.currentUser()
      
      currentUser.setValue("Test", forKey: "UserLocation")
      currentUser.saveInBackgroundWithBlock {
         (success: Bool, error: NSError!) -> Void in
         if success {
            println("Successfully saved user")
         } else {
            println("Error in saving: \(error.description)")
         }
      }
   }
   
   @IBOutlet weak var locationLabel: UILabel!
   
   @IBAction func updateUser(sender: UIButton) {
      let currentUser = PFUser.currentUser()
      
      locationLabel.text = currentUser.valueForKey("UserLocation") as? String
   }
   
   
   @IBAction func setLocation2(sender: UIButton) {
      var currentUser = PFUser.currentUser()
      
      currentUser.setValue("Second Button", forKey: "UserLocation")
      currentUser.saveInBackgroundWithBlock {
         (success: Bool, error: NSError!) -> Void in
         if success {
            println("Successfully saved user")
         } else {
            println("Error in saving: \(error.description)")
         }
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      var currentUser = PFUser.currentUser()
      if currentUser != nil {
         println("Refreshing (fetching) user")
         currentUser.fetch()
         
         // Do stuff with the user
         for key in currentUser.allKeys() {
            println("\(key): \(currentUser[key as String])")
         }
      } else {
         // Show the signup or login screen
         println("ERROR: currentUser is nil!")
      }
      
      var query = PFQuery(className:"FriendRequests")
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

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }


}

