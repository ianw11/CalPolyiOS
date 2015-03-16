//
//  SecondViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 2/19/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class FriendTableViewController: UITableViewController {
   
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   var request: PFObject? = nil
   
   var dataToDisplay: [String] = []
   
   @IBOutlet weak var seeFriendsButton: UIButton!
   var isSeeFriends = false;
   
   var pullToRefreshControl = UIRefreshControl()
   
   var userForDetails: PFUser? = nil
   
   
   @IBOutlet weak var friendListView: UITableView!
   
   @IBAction func AddFriend(sender: UIButton) {
      let alert = UIAlertController(title: "Add Friend", message: "Enter friend's email", preferredStyle: UIAlertControllerStyle.Alert)
      
      
      let action = UIAlertAction(title: "Send Request!", style: UIAlertActionStyle.Default, handler: { (something: UIAlertAction!) -> Void in
         if let tField = alert.textFields?.first as? UITextField {
            if !tField.text.isEmpty {
               // Code to add friend
               let currUser = PFUser.currentUser()
               if (currUser["Friends"] == nil) {
                  currUser["Friends"] = []
               }
               
               let friendsArr = currUser["Friends"] as [String]
               
               let friendEmail = tField.text! as String
               
               if contains(friendsArr, friendEmail) {
                  return
               } else {
                  // Add user to their friend request object
                  var query = PFQuery(className: "FriendRequests")
                  query.whereKey("OwnedBy", equalTo: friendEmail)
                  query.findObjectsInBackgroundWithBlock {
                     (objects: [AnyObject]!, error: NSError!) -> Void in
                     
                     if (objects.count != 1) {
                        return
                     }
                     
                     // Add the current user as a potential to the other
                     let other = objects[0] as PFObject
                     if other["Requests"] == nil {
                        other["Requests"] = []
                     }
                     
                     var reqArr = other["Requests"] as [String]
                     reqArr.append(currUser.email!)
                     other["Requests"] = reqArr
                     
                     other.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError!) -> Void in
                        // Nothing
                     }
                     
                  }
               }
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
         textField.textColor = UIColor.redColor()
      }
      
      
      
      self.presentViewController(alert, animated: true) { () -> Void in
         // nothing
      }
   }
   
   @IBAction func toggleListView(sender: UIButton) {
      if isSeeFriends {
         isSeeFriends = false
         seeFriendsButton.setTitle("See Friend List", forState: UIControlState.Normal)
      } else {
         isSeeFriends = true
         seeFriendsButton.setTitle("See Active Posts", forState: UIControlState.Normal)
      }
      
      populate()
   }
   
   func updateData() {
      var query = PFQuery(className:"FriendRequests")
      query.whereKey("OwnedBy", equalTo: PFUser.currentUser().email!)
      query.findObjectsInBackgroundWithBlock{
         (objects: [AnyObject]!, error: NSError!) -> Void in
         
         if (error == nil) {
            if let objects = objects as? [PFObject] {
               
               if objects.count == 1 {
                  self.request = objects.first
                  
                  let currUser = PFUser.currentUser()
                  var friendArr = currUser["Friends"] as [String]
                  
                  /* Add all Accepted friends to Friends */
                  let acceptedArr: [String] = self.request!["AcceptedRequests"] as [String]
                  
                  for accepted in acceptedArr {
                     friendArr.append(accepted)
                     
                     /*
                     var acceptedQuery = PFQuery(className: "FriendRequests")
                     acceptedQuery.whereKey("OwnedBy", equalTo: accepted)
                     acceptedQuery.findObjectsInBackgroundWithBlock {
                        (bobjects: [AnyObject]!, error: NSError!) -> Void in
                        
                        let objects = bobjects as [PFObject]
                        let person = objects.first
                        var arr = (person!["AcceptedRequests"] as [String])
                        arr.append(currUser.email)
                        person!["AcceptedRequests"] = arr
                        person?.save()
                     }
                     */
                  }
                  
                  /* Remove all deleted friends */
                  let deletedArr: [String] = self.request!["DeletedFriends"] as [String]
                  
                  for deleted in deletedArr {
                     
                     // Find the index of the friend to remove
                     var ndx = -1
                     for (elem, friend) in enumerate(friendArr) {
                        if friend == deleted {
                           ndx = elem
                        }
                     }
                     
                     // Then remove it
                     friendArr.removeAtIndex(ndx)
                  }
                  
                  
                  /* Update server */
                  if acceptedArr.count > 0 || deletedArr.count > 0 {
                     currUser["Friends"] = friendArr
                     // Immediately save
                     currUser.save()
                     //currUser.saveInBackgroundWithBlock(nil)
                     
                     self.request!["AcceptedRequests"] = []
                     self.request!["DeletedFriends"] = []
                     self.request!.saveInBackgroundWithBlock(nil)
                  }
                  
                  self.populate()
                  
                  
               } else {
                  println("Received too many objects, this shouldn't happen")
               }
            }
         } else {
            println("Query failed")
         }
      }
      
   }
   
   func populate() {
      if isSeeFriends {
         populateAllFriends()
      } else {
         populateFreeFriends()
      }
   }
   
   func populateFreeFriends() {
      PFUser.currentUser().fetchIfNeeded()
      
      let currUser = PFUser.currentUser()
      
      let query = PFUser.query()
      query.whereKey("TimeFree", greaterThan: NSDate()) // Greater than the current time
      query.findObjectsInBackgroundWithBlock {
         (gen_objects: [AnyObject]!, error: NSError!) -> Void in
         
         var activeUsers: [String] = []
         
         println("Query came back")
         
         if error == nil {
            
            let objects = gen_objects as [PFUser]
            let friendArr = currUser["Friends"] as [String]
            
            for user in objects {
               let userDate: NSDate = user["TimeFree"] as NSDate
               if contains(friendArr, user.email)  {
                  activeUsers.append(user.email)
               }
            }
            
            
         } else {
            println("Error: \(error)")
         }
         
         self.dataToDisplay = activeUsers
         self.friendListView.reloadData()
         self.pullToRefreshControl.endRefreshing()
         
      }
      
      
   }

   func populateAllFriends() {
      dataToDisplay = PFUser.currentUser()["Friends"] as [String]
      self.friendListView.reloadData()
      self.pullToRefreshControl.endRefreshing()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      friendListView.delegate = self
      friendListView.dataSource = self
      friendListView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      
      updateData()
      
      pullToRefreshControl.addTarget(self, action: Selector("populate"), forControlEvents: UIControlEvents.ValueChanged)
      pullToRefreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
      friendListView.addSubview(pullToRefreshControl)
      
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return dataToDisplay.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
      
      cell.textLabel?.text = dataToDisplay[indexPath.row]
      
      //cell.clipsToBounds = true
      
      return cell
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if isSeeFriends {
         // Enable deleting
         let alert = UIAlertController(title: "Delete Friend?", message: "Is this ok?", preferredStyle: UIAlertControllerStyle.Alert)
         
         let action = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (something: UIAlertAction!) -> Void in
            
            // Handle the user deleting
            let deleted = self.dataToDisplay[indexPath.row]
            self.dataToDisplay.removeAtIndex(indexPath.row)
            PFUser.currentUser()["Friends"] = self.dataToDisplay
            PFUser.currentUser().saveInBackgroundWithBlock(nil)
            
            self.friendListView.reloadData()
            
            // Be sure to let the other user know you've deleted them
            let query = PFQuery(className: "FriendRequests")
            query.whereKey("OwnedBy", equalTo: deleted)
            query.findObjectsInBackgroundWithBlock {
               (gen_objects: [AnyObject]!, error: NSError!) -> Void in
               
               if error == nil {
                  let objects = gen_objects as [PFObject]
                  let otherUser = objects.first
                  var delArr = otherUser!["DeletedFriends"] as [String]
                  
                  delArr.append(PFUser.currentUser().email)
                  otherUser!["DeletedFriends"] = delArr
                  otherUser?.saveInBackgroundWithBlock(nil)
               }
            }
            // And now the other user should know
            
         })
         alert.addAction(action)
         
         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
         }
         alert.addAction(cancelAction)
         
         self.presentViewController(alert, animated: true) { () -> Void in
            // nothing
         }
         
      } else {
         // Show full details
         let query = PFUser.query()
         query.whereKey("email", equalTo: dataToDisplay[indexPath.row])
         query.findObjectsInBackgroundWithBlock {
            (gen_objects: [AnyObject]!, error: NSError!) -> Void in
            
            let objects = gen_objects as [PFUser]
            self.doSegue(objects)
         }
      }
   }
   
   func doSegue(users: [PFUser]) {
      userForDetails = users.first
      performSegueWithIdentifier("postSegue", sender: self)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
      if segue.identifier == "postSegue" {
         let target = segue.destinationViewController as PostViewController
         
         target.user = userForDetails
      }
      
   }
   
   

   @IBAction func logout(sender: UIBarButtonItem) {
      PFUser.currentUser()
      PFUser.logOut()
      
      PersistanceUtils.dropCredentials()
      
      self.performSegueWithIdentifier("logOut2", sender: self)
   }

}

