//
//  EnrollmentTableViewController.swift
//  GradebookExample
//
//  Created by Ian Washburne on 3/3/15.
//  Copyright (c) 2015 John Bellardo. All rights reserved.
//

import UIKit

class EnrollmentCell: UITableViewCell {
   
   @IBOutlet weak var enrollmentLabel: UILabel!
   
   required init(coder aDecoder: NSCoder) {
      enrollment = nil
      super.init(coder: aDecoder)
   }
   
   var id = 0
   var emplid = 0
   var username = ""
   var ferpa = 0
   var age = 0
   var csc_username = ""
   var bb_id = ""
   var middle_name = ""
   var email_level = 0
   var last_name = ""
   var role = 0
   var picture: JSON? = nil
   var admin_failure = 0
   var major = ""
   var first_name = ""
   var dropped = 0
   
   /*
"picture" : {
"id" : 32550,
"file_extension" : ".jpg",
"mimetype" : "image\/jpeg",
"url" : "\/~bellardo\/cgi-bin\/file_download?file=32550&enrollment=858&name=file&term=2152&course=458"
}
   */

   var enrollment: JSON? {
      didSet {
         if let enrollment = enrollment? {
            
            id = enrollment["id"].int!
            username = enrollment["username"].string!
            age = enrollment["age"].int!
            first_name = enrollment["first_name"].string!
            last_name = enrollment["last_name"].string!
            
            let str = "\(first_name) \(last_name) -- Year: \(age)"
            
            enrollmentLabel.text = str
         } else {
            enrollmentLabel.text = "EMPTY"
         }
      }
   }
   
   override func prepareForReuse() {
      enrollment = nil
   }
   
}

class EnrollmentTableViewController: UITableViewController {
   
   var username = ""
   var password = ""
   
   var term = 0
   var course = ""
   
   var url = ""
   
   let reuseIdentifier = "enrollmentCell"
   
   var enrollmentData: JSON? {
      didSet {
         self.tableView.reloadData()
      }
   }
   
   func loadData() {
      let loader = GradebookURLLoader()
      // Run the loader
      loader.baseURL = url
      
      if loader.loginWithUsername(username, andPassword: password) {
         
         let data = loader.loadDataFromPath("?record=enrollments&term=\(term)&course=\(course)", error: nil)
         
         enrollmentData = JSON(data: data)
         
      }
      else {
         println("Auth failed!")
      }
      
   }

   override func viewDidLoad() {
      loadData()
      
      super.viewDidLoad()

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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      if let enrollments = enrollmentData?["enrollments"].array? {
         return enrollments.count
      }
      
        return 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as EnrollmentCell

        // Configure the cell...
      if let enrollment = enrollmentData?["enrollments"].array?[indexPath.row] {
         cell.enrollment = enrollment
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

   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      self.performSegueWithIdentifier("enrollmentSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
   }
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
      let target = segue.destinationViewController as UserScoreTableViewController
      let from = sender as EnrollmentCell
      
      target.url = self.url
      target.username = self.username
      target.password = self.password
      
      target.term = self.term
      target.course = self.course
      target.user = from.username
    }

}
