//
//  UserScoreTableViewController.swift
//  GradebookExample
//
//  Created by Ian Washburne on 3/3/15.
//  Copyright (c) 2015 John Bellardo. All rights reserved.
//

import UIKit

class UserScoreCell: UITableViewCell {
   
   @IBOutlet weak var userScoreLabel: UILabel!
   
   required init(coder aDecoder: NSCoder) {
      userScore = nil
      super.init(coder: aDecoder)
   }
   
   var id = 0
   var extra_credit_allowed = 0
   var max_points = 0
   var email_notification = 0
   var scores: JSON?
   var compute_func = 0
   var display_type = 0
   var due_date = 0
   var permissions: JSON?
   var name = ""
   var abbreviated_name = ""
   var sort_order = 0
   
   var display_score = ""
   
   var userScore: JSON? {
      didSet {
         if let us = userScore? {
            name = us["name"].string!
            id = us["id"].int!
            
            
            if us["scores"][0]["display_score"].string == nil {
               let disp = us["scores"][0]["display_score"].float!
               display_score = "\(disp)"
            } else {
               display_score = us["scores"][0]["display_score"].string!
            }

         
            let str = "\(name)"
            userScoreLabel.text = str
         } else {
            userScoreLabel.text = "EMPTY"
         }
      }
   }
   
   override func prepareForReuse() {
      userScore = nil
   }
   
}

class UserScoreTableViewController: UITableViewController {
   
   let reuseIdentifier = "userScoreCell"
   
   var url = ""
   var username = ""
   var password = ""
   
   var term = 0
   var course = ""
   var user = ""
   
   var userScores: JSON? {
      didSet {
         self.tableView.reloadData()
      }
   }
   
   func loadData() {
      let loader = GradebookURLLoader()
      // Run the loader
      loader.baseURL = url
      
      if loader.loginWithUsername(username, andPassword: password) {
         
         let data = loader.loadDataFromPath("?record=userscores&term=\(term)&course=\(course)&user=\(user)", error: nil)
         
         userScores = JSON(data: data)
         
      }
      else {
         println("Auth failed!")
      }
      
   }
   
   

   override func viewDidLoad() {
      super.viewDidLoad()
      
      loadData()

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
        // Return the number of sections.
        return 1
    }

   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
      if let arr = userScores?["userscores"].array? {
         return arr.count
      }
      
      return 0
    }

   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UserScoreCell

        // Configure the cell...
      
      if let score = userScores?["userscores"].array?[indexPath.row] {
         cell.userScore = score
      }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
      
      let from = sender as UserScoreCell
      let target = segue.destinationViewController as AssignmentTableViewController
      
      target.url = self.url
      target.username = self.username
      target.password = self.password
      
      target.term = self.term
      target.course = self.course
      target.id = from.id
      
      target.display_score = from.display_score
      
    }
   

}
