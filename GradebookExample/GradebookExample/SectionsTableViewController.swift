//
//  SectionsTableViewController.swift
//  GradebookExample
//
//  Created by Ian Washburne on 3/3/15.
//  Copyright (c) 2015 John Bellardo. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

   required init(coder aDecoder: NSCoder) {
      section = nil
      super.init(coder: aDecoder)
   }
   
   @IBOutlet weak var sectionLabel: UILabel!
   
   var term: Int = 0
   var sectionId: Int = 0
   var termName: String = ""
   var title: String = ""
   var dept: String = ""
   var course: String = ""
   
   var section: JSON? {
      didSet {
         if let section = section? {
            sectionId = section["id"].int!
            termName = section["termname"].string!
            title = section["title"].string!
            dept = section["dept"].string!
            course = section["course"].string!
            term = section["term"].int!
            
            sectionLabel.text = "\(dept) \(course) Section \(sectionId) -- \(title)"
         } else {
            sectionLabel.text = "Empty"
         }
      }
   }
   
   override func prepareForReuse() {
      section = nil
   }
   
}

class SectionsTableViewController: UITableViewController {
   
   var sectionData: JSON? {
      didSet {
         self.tableView!.reloadData()
      }
   }
   
   let reuseIdentifier = "cellReuseIdentifier"
   
   var username = "test"
   var password = "kj34mns04d"
   var url = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json"

   @IBAction func changeUser(sender: AnyObject) {
      
      let alert = UIAlertController(title: "Login", message: "Swap user", preferredStyle: UIAlertControllerStyle.Alert)
      
      
      let action = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { (something: UIAlertAction!) -> Void in
         
         if let tField = alert.textFields?.first as? UITextField {
            if !tField.text.isEmpty {
               
               if let pField = alert.textFields?[1] as? UITextField {
                  if !pField.text.isEmpty {
                     
                     self.username = tField.text
                     self.password = pField.text
                     
                     self.url = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/grades.json"
                     
                     self.login()
                     
                  }
               }
            }
         }
      })
      alert.addAction(action)
      
      let defaultAction = UIAlertAction(title: "Default", style: .Default, handler: { (something: UIAlertAction!) -> Void in
         
         self.username = "test"
         self.password = "kj34mns04d"
         
         self.url = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json"
         
         self.login()
         
      })
      alert.addAction(defaultAction)
      
      let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
         //Just dismiss the action sheet
      }
      alert.addAction(cancelAction)
      
      
      alert.addTextFieldWithConfigurationHandler { textField -> Void in
         //TextField configuration
         textField.textColor = UIColor.blueColor()
         textField.placeholder = "Username"
      }
      alert.addTextFieldWithConfigurationHandler { textField -> Void in
         //TextField configuration
         textField.textColor = UIColor.blueColor()
         textField.placeholder = "Password"
         textField.secureTextEntry = true
      }
      
      self.presentViewController(alert, animated: true) { () -> Void in
         // nothing
      }
      
   }
   
   func login() {
      let loader = GradebookURLLoader()
      // Run the loader
      loader.baseURL = url
      
      if loader.loginWithUsername(username, andPassword: password) {
         println("Auth worked!")
         let data = loader.loadDataFromPath("?record=sections", error: nil)
         
         sectionData = JSON(data: data)
         
         //let str = NSString(data: data, encoding: NSUTF8StringEncoding)
      }
      else {
         println("Auth failed!")
      }
      
   }
   
   
   
   
   override func viewDidLoad() {
      
      // Test data URL
      login()
      
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
      // Return the number of rows in the section.
      if let sections = sectionData?["sections"].array? {
         return sections.count
      }
      
      return 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as SectionCell

      // Configure the cell...
      if let section = sectionData?["sections"].array?[indexPath.row] {
         cell.section = section
      } else {
         cell.section = nil
      }

        return cell
    }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      let row = tableView.cellForRowAtIndexPath(indexPath)
      
      self.performSegueWithIdentifier("sectionSegue", sender: row)
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
      
      let target = segue.destinationViewController as EnrollmentTableViewController
      
      if let from = sender as? SectionCell {
      
         target.username = self.username
         target.password = self.password
         target.course = from.course
         target.term = from.term
         target.url = self.url
      } else {
         println("sender is not a section cell")
      }
      
   }

}
