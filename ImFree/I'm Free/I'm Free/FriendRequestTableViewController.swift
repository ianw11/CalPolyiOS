//
//  FriendRequestTableViewController.swift
//  I'm Free
//
//  Created by Ian Washburne on 3/15/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

   required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
   }
   
   weak var controller: FriendRequestTableViewController? = nil

   @IBOutlet weak var friendRequestName: UILabel!
   
   @IBAction func reject(sender: AnyObject) {
      controller!.rejectFriend(self.friendRequestName.text!)
   }
   
   @IBAction func accept(sender: UIButton) {
      controller!.acceptFriend(self.friendRequestName.text!)
   }
   
}

class FriendRequestTableViewController: UITableViewController {
   
   let reuseIdentifier = "FriendRequestCell"
   
   var requests: [String] = [] {
      didSet {
         self.tableView.reloadData()
      }
   }
   
   func updateData() {
      var query = PFQuery(className:"FriendRequests")
      query.whereKey("OwnedBy", equalTo: PFUser.currentUser().email!)
      query.findObjectsInBackgroundWithBlock{
         (objects: [AnyObject]!, error: NSError!) -> Void in
         
         if (error == nil) {
            if let objects = objects as? [PFObject] {
               
               if objects.count == 1 {
                  //self.request = objects.first
                  let request = objects.first
                  
                  let arr: [String] = request!["Requests"] as [String]
                  
                  self.requests = arr
               } else {
                  println("objects.count != 1")
               }
            }
         }
      }
   }
   
   func acceptFriend(friend: String) {
      var query = PFQuery(className:"FriendRequests")
      query.whereKey("OwnedBy", equalTo: PFUser.currentUser().email!)
      query.findObjectsInBackgroundWithBlock{
         (objects: [AnyObject]!, error: NSError!) -> Void in
         
         if (error == nil) {
            if let objects = objects as? [PFObject] {
               if objects.count == 1 {
                  let request = objects.first
                  
                  /* Remove the current name from the server */
                  var requestArr = request!["Requests"] as [String]
                  
                  // Remove all elements whose email matches
                  var toRemove: [Int] = []
                  for (index, element) in enumerate(requestArr) {
                     if element == friend {
                        toRemove.append(index)
                     }
                  }
                  
                  for idx in toRemove {
                     requestArr.removeAtIndex(idx)
                  }
                  
                  request!["Requests"] = requestArr
                  request?.saveInBackgroundWithBlock(nil)
                  /* Done with removing from server */
                  
                  // Refresh the local list
                  self.requests = requestArr
                  
                  
                  /* Add user to current user's friends */
                  let currentUser = PFUser.currentUser()
                  var friendArr = currentUser["Friends"] as [String]
                  friendArr.append(friend)
                  currentUser["Friends"] = friendArr
                  currentUser.saveInBackgroundWithBlock(nil)
                  
                  
                  /* Add this person to the other user's accepted */
                  var otherQuery = PFQuery(className: "FriendRequests")
                  otherQuery.whereKey("OwnedBy", equalTo: friend)
                  otherQuery.findObjectsInBackgroundWithBlock {
                     (objects: [AnyObject]!, error: NSError!) -> Void in
                     
                     if (error == nil) {
                        if objects.count > 1 {
                           println("Error! Too many objects")
                        }
                        
                        if let objects = objects as? [PFObject] {
                           
                           let otherUser = objects.first
                           var otherArr = otherUser!["AcceptedRequests"] as [String]
                           otherArr.append(currentUser.email!)
                           otherUser!["AcceptedRequests"] = otherArr
                           otherUser!.saveInBackgroundWithBlock(nil)
                           
                        }
                     }
                  }
                  /* Done with adding self to other */
                  
               }
            }
         }
      }
   }
   
   
   func rejectFriend(friend: String) {
      var query = PFQuery(className:"FriendRequests")
      query.whereKey("OwnedBy", equalTo: PFUser.currentUser().email!)
      query.findObjectsInBackgroundWithBlock{
         (objects: [AnyObject]!, error: NSError!) -> Void in
         
         if (error == nil) {
            if let objects = objects as? [PFObject] {
               if objects.count == 1 {
                  let request = objects.first
                  var requestArr = request!["Requests"] as [String]
                  
                  var toRemove: [Int] = []
                  for (index, element) in enumerate(requestArr) {
                     if element == friend {
                        toRemove.append(index)
                     }
                  }
                  
                  for idx in toRemove {
                     requestArr.removeAtIndex(idx)
                  }
                  
                  request!["Requests"] = requestArr
                  
                  request?.saveInBackgroundWithBlock(nil)
                  
                  self.requests = requestArr
               }
            }
         }
      }
   }
   

   override func viewDidLoad() {
      super.viewDidLoad()
      
      updateData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return requests.count
    }

   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as FriendRequestCell

      // Configure the cell...
      cell.friendRequestName.text = requests[indexPath.row]
      cell.controller = self

      return cell
   }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
