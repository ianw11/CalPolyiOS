//
//  FirstViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/19/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

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

